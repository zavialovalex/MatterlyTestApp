//
//  M0vieControllerCell.swift
//  Matterly Test App
//
//  Created by User on 9/13/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import UIKit

class MovieControllerCell: UITableViewCell, UIObjectProtocol, MovieControllerContainerProtocol {

    class var identifier: String { return "MovieControllerCell" }
    class var nibFile: UINib? { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var titleView: UILabel?
    @IBOutlet weak var collectionView: UICollectionView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    func configureWithController(_ controller: MovieController) {
        controller.collectionView = collectionView
        titleView?.text = controller.title
    }
}
