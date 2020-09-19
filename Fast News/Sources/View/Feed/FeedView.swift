//
//  FeedView.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import UIKit

// MARK: - Protocol -

protocol FeedViewDelegate {
    func didTouch(cell: FeedCell, indexPath: IndexPath)
    func didGetInTheBottom()
}

// MARK: - Extension -

extension FeedViewDelegate {
    func didGetInTheBottom() {}
}

// MARK: -

class FeedView: UIView {
    
    // MARK: - Constants -
    
    let activityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModels: [HotNewsViewModel] = [HotNewsViewModel]() {
        didSet {
            tableView.backgroundView = nil
            tableView.reloadData()
        }
    }
    var delegate: FeedViewDelegate?
    
    // MARK: - Public Methods
    
    func setup(with viewModels: [HotNewsViewModel], and delegate: FeedViewDelegate) {
        tableView.register(UINib(nibName: "FeedCell", bundle: Bundle.main), forCellReuseIdentifier: "FeedCell")
        
        self.delegate = delegate
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = activityIndicatorView
        
        activityIndicatorView.startAnimating()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource -

extension FeedView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else { fatalError("Cell is not of type FeedCell!") }
        
        cell.setup(hotNewsViewModel: viewModels[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FeedCell else { fatalError("Cell is not of type FeedCell!") }
        
        delegate?.didTouch(cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return activityIndicatorView
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        activityIndicatorView.startAnimating()
        delegate?.didGetInTheBottom()
    }
}
