//
//  MoviesDataMapper.swift
//  Matterly Test App
//
//  Created by User on 9/13/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import Foundation
import TMDBSwift

struct MoviesDataMapper {
    
    private var movies: [MovieMDB]
    init(movies: [MovieMDB]) {
        self.movies = movies
    }
    
    func mappedResult()-> [MovieDisplayingModel] {
        return movies.map { movie in MovieDisplayingModel(movie: movie) }
    }
}
