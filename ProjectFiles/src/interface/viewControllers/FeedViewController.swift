//
//  ViewController.swift
//  Matterly Test App
//
//  Created by User on 9/13/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var items: [MovieController] =  {
        var items =
        stride(from: 0, to: MatterlyApiService.SortParam.count, by: 1)
            .map { MovieController(sortParam: MatterlyApiService.SortParam.withIndex($0)) }
        
        
        return items
    }()
    
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let cellNib = MovieControllerCell.nibFile {
            tableView?.register(cellNib, forCellReuseIdentifier: MovieControllerCell.identifier)
            tableView?.dataSource = self
            tableView?.delegate = self
            tableView?.reloadData()
        }
    }

    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieControllerCell.identifier, for: indexPath) as! MovieControllerCell
        cell.configureWithController(items[indexPath.row])
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
}

