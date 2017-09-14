//
//  MatterlyDataManager.swift
//  Matterly Test App
//
//  Created by User on 9/13/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import Foundation
import TMDBSwift

import RxSwift


class MatterlyDataManager {
    
    static let shared = MatterlyDataManager()
    private let scheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "MatterlyDataManager.processing", attributes: .concurrent))
    
    func getMoviesSortedBy(_ sortParam: MatterlyApiService.SortParam, page: Int = 1)-> Observable<(movies: [MovieDisplayingModel], pages: MatterlyApiService.PagesResult)> {
        return MatterlyApiService.getMoviesSortedBy(sortParam, page: page)
                .observeOn(scheduler)
                .map({ (result: (movies: [MovieMDB], pages: MatterlyApiService.PagesResult)) in
                    (MoviesDataMapper(movies: result.movies).mappedResult(), result.pages)
                })
                .observeOn(MainScheduler.instance)
    }
}
