//
//  MovieCell.swift
//  Matterly Test App
//
//  Created by User on 9/13/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import UIKit
import RxSwift

class MovieCell: UICollectionViewCell, UIObjectProtocol, MovieDisplayingModelContainer {

    class var identifier: String { return "MovieCell" }
    class var nibFile: UINib? { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var movieTitleView: UILabel?
    @IBOutlet weak var moviePreviewView: MImageView?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    private var disposeBag = DisposeBag()
    
    func configureWithMovie(_ movie: MovieDisplayingModel) {
        movieTitleView?.text = movie.title
        if let previewPath = movie.preview {
            self.activityIndicator?.startAnimating()
            moviePreviewView?.setImageFromUrlString(previewPath, finished: { [weak self] image  in
                self?.activityIndicator?.stopAnimating()
            })
        } else {
            self.activityIndicator?.stopAnimating()
            moviePreviewView?.cancelLoading()
        }
    }

}
