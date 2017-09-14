//
//  MoviesDataSource.swift
//  Matterly Test App
//
//  Created by User on 9/13/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import UIKit
import RxSwift

private let MoviesDataSource_MinPage: Int = 1

class MoviesDataSource<MovieCell: UIObjectProtocol & MovieDisplayingModelContainer>: NSObject, UICollectionViewDataSource {
    
    enum LoadType: Int {
        case load, loadMore, reload
    }
    
    private(set) var movies = [MovieDisplayingModel]()
    private(set) weak var moviesCollectionView: UICollectionView?
    private(set) var requestPage: Int = MoviesDataSource_MinPage
    private(set) var maxPages: Int = Int.max
    private(set) var sortParam: MatterlyApiService.SortParam
    
    private(set) var loadingTracker = AppActivityTracker()
    private(set) var loadType = LoadType.load
    
    var canLoadMore: Bool {
        return self.requestPage < self.maxPages
    }
    private let disposeBag = DisposeBag()
    
    func movieAtIndexPath(_ indexPath: IndexPath)-> MovieDisplayingModel {
        return movies[indexPath.row]
    }
    
    init(collectionView: UICollectionView? = nil, withSortParam param: MatterlyApiService.SortParam) {
        sortParam = param
        super.init()
        
        setCollectionView(collectionView)
    }
    
    func setCollectionView(_ collectionView: UICollectionView?) {
        
        moviesCollectionView = collectionView
        
        if let cellNib = MovieCell.nibFile, let loadingFooter = MovieFooterView.nibFile, let newCollectionView = collectionView {
            newCollectionView.register(cellNib, forCellWithReuseIdentifier: MovieCell.identifier)
            newCollectionView.register(loadingFooter, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: MovieFooterView.identifier)
            newCollectionView.dataSource = self
            newCollectionView.reloadData()
        }
    }
    
    func loadData(_ loadType: LoadType = .load)-> Observable<Bool> {
        
        var nextPage = requestPage
        
        if (loadType == .reload) {
            nextPage = MoviesDataSource_MinPage
        } else if loadingTracker.active {
            return Observable.just(false)
        } else if !canLoadMore {
            return Observable.just(false)
        } else if (loadType == .loadMore) {
            nextPage = requestPage + 1
        }
        self.loadType = loadType
        
        return MatterlyDataManager.shared.getMoviesSortedBy(sortParam, page: nextPage)
            .trackActivity(loadingTracker.rx_activityTracker)
            .do(onNext: { (result: (movies: [MovieDisplayingModel], pages: MatterlyApiService.PagesResult)) in
                self.requestPage = result.pages.currentPage
                self.maxPages = result.pages.maxPages
                
                print("\(self.sortParam.rawValue) pages \(self.maxPages) currentPage \(self.requestPage)")
                if loadType == .loadMore {
                    self.movies += result.movies
                } else {
                    self.movies = result.movies
                }
                self.moviesCollectionView?.reloadData()
            }).map { _,_ in return true }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath)
        (cell as? MovieCell)?.configureWithMovie(movieAtIndexPath(indexPath))
        
        let positionForLoadMore = max(movies.count - 2, 0)
        if (positionForLoadMore > 0)
            && (indexPath.row == positionForLoadMore) {
            loadData(.loadMore)
            .subscribe( )
            .addDisposableTo(disposeBag)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionFooter) {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: MovieFooterView.identifier, for: indexPath)
            return footer
        }
        return UICollectionReusableView()
    }
}
