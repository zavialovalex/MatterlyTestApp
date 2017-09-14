//
//  MatterlyApiService.swift
//  Matterly Test App
//
//  Created by User on 9/13/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import Foundation
import TMDBSwift

import RxSwift

internal final class MatterlyApiService {
    private static let apiKey = "8a7a49369d1af6a70ec5a6787bbfcf79"
    
    enum SortParam: String {
        static let count: Int = 3
        case newestInTheatres = "New in Theatres", mostPopular = "Popular", ratedThisYear = "Highest Rated This Year"
        
        static func withIndex(_ index: Int)-> SortParam {
            switch index {
            case 1:
                return SortParam.mostPopular
            case 2:
                return SortParam.ratedThisYear
            default:
                return SortParam.newestInTheatres
            }
        }
    }
    
    struct PagesResult {
        private(set) var currentPage: Int
        private(set) var maxPages: Int
    }
    
    class func getMoviesSortedBy(_ sortParam: SortParam, page: Int = 1)-> Observable<(movies: [MovieMDB], pages: PagesResult)> {
        return Observable.create({ observer in
            
            let finalResults = { (clientResult: ClientReturn, movies: [MovieMDB]?) in
                if let error = clientResult.error {
                    observer.onError(error)
                } else if let result = movies {
                    var pagesResult = PagesResult(currentPage: page, maxPages: Int.max)
                    if let moviesPagesResult = clientResult.pageResults {
                        pagesResult = PagesResult(currentPage: moviesPagesResult.page, maxPages: moviesPagesResult.total_pages)
                    }
                    observer.onNext((result,pagesResult))
                }
                observer.onCompleted()
            }
            
            switch sortParam {
            case .newestInTheatres:
                MovieMDB.nowplaying(apiKey, page: page, completion: finalResults)
            case .mostPopular:
                MovieMDB.discoverMovies(apikey: apiKey, page: Double(page), sort_by: .popularity_desc, primary_release_year: DateUtil().currentYearString(), completion: finalResults)
//                MovieMDB.popular(apiKey, page: page, completion: finalResults)
            case .ratedThisYear:
                MovieMDB.discoverMovies(apikey: apiKey, page: Double(page), sort_by: .vote_count_desc, primary_release_year: DateUtil().currentYearString(), vote_average_gte: 5.0, completion: finalResults)
            }
            
            
            return Disposables.create()
        })
    }
}
