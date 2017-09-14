//
//  MovieFooterView.swift
//  Matterly Test App
//
//  Created by User on 9/14/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import UIKit

class MovieFooterView: UICollectionReusableView, UIObjectProtocol {

    class var identifier: String {
        return "MovieFooterView"
    }
    
    class var nibFile: UINib? {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
