//
//  MovieObject.swift
//  Matterly Test App
//
//  Created by User on 9/13/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import Foundation
import TMDBSwift

class MovieDisplayingModel {
    
    var title: String {
        return movie.title ?? movie.original_title ?? ""
    }
    
    var preview: String? {
        if let path = movie.poster_path {
            return "https://image.tmdb.org/t/p/w640\(path)"
        }
        return nil
    }
    
    private(set) var movie: MovieMDB
    
    init(movie: MovieMDB) {
        self.movie = movie
    }
}

protocol MovieDisplayingModelContainer: class {
    
    func configureWithMovie(_ movie: MovieDisplayingModel)
}
