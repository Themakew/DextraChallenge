//
//  FeedViewController.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import Foundation
import UIKit

// MARK: -

class FeedViewController: UIViewController {
    
    // MARK: - Constants -
    
    let kToDetails: String = "toDetails"
    
    // MARK: - Properties -
    
    private var viewModels: [HotNewsViewModel] = [HotNewsViewModel]()
    
    var newHotNews: [HotNews] = [HotNews]() {
        didSet {
            var newViewModels: [HotNewsViewModel] = [HotNewsViewModel]()
            
            _ = newHotNews.map { (news) in
                newViewModels.append(HotNewsViewModel(hotNews: news))
            }
            
            viewModels.append(contentsOf: newViewModels)
            self.mainView.viewModels = self.viewModels
        }
    }
    
    var mainView: FeedView {
        guard let view = self.view as? FeedView else {
            fatalError("View is not of type FeedView!")
        }
        return view
    }
    
    private var baseNumberOfNews: Int = 5
    
    // MARK: - Override Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Fast News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchFeed()
        mainView.setup(delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let hotNewsViewModel = sender as? HotNewsViewModel else { return }
        guard let detailViewController = segue.destination as? FeedDetailsViewController else { return }
        
        detailViewController.hotNewsViewModel = hotNewsViewModel
    }
    
    // MARK: - Private Methods -
    
    private func fetchFeed() {
        HotNewsProvider.shared.hotNews { [weak self] (completion) in
            guard let self = self else { return }
            
            do {
                let hotNews = try completion()
                
                self.newHotNews = hotNews
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - FeedViewDelegate -

extension FeedViewController: FeedViewDelegate {
    func didGetInTheBottom() {
        fetchFeed()
    }
    
    func didTouch(cell: FeedCell, indexPath: IndexPath) {
        self.performSegue(withIdentifier: kToDetails, sender: self.mainView.viewModels[indexPath.row])
    }
}
