//
//  MovieController.swift
//  Matterly Test App
//
//  Created by User on 9/13/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MovieController: NSObject, UICollectionViewDelegateFlowLayout {

    var title: String?
    
    @IBOutlet weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.delegate = self
            moviesDataSource.setCollectionView(collectionView)
            if collectionView != nil {
                preloadData()
            }
        }
    }
    
    private var isdataPreloaded: Bool = false
    
    private(set) var moviesDataSource: MoviesDataSource<MovieCell>
    
    private(set) var disposeBag = DisposeBag()
    
    init(collectionView: UICollectionView? = nil, sortParam param: MatterlyApiService.SortParam) {
        title = param.rawValue
        moviesDataSource = MoviesDataSource(collectionView: collectionView, withSortParam: param)
        super.init()
        
        self.collectionView = collectionView
    }
    
    private func preloadData() {
        guard !isdataPreloaded else {
            return
        }
        
        isdataPreloaded = true
        moviesDataSource.loadData()
        .subscribe(onNext: { success in
            
        })
        .addDisposableTo(disposeBag)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width * 0.8), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return (moviesDataSource.canLoadMore) ? CGSize(width: (collectionView.frame.width), height: collectionView.frame.height) : CGSize.zero
    }
}


protocol MovieControllerContainerProtocol {
    var collectionView: UICollectionView? { get set }
    func configureWithController(_ controller: MovieController)
}
