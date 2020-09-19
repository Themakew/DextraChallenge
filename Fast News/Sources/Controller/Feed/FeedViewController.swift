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
    
    var hotNews: [HotNews] = [HotNews]() {
        didSet {
            var viewModels: [HotNewsViewModel] = [HotNewsViewModel]()
            _ = hotNews.map { (news) in
                viewModels.append(HotNewsViewModel(hotNews: news))
            }
            
            self.mainView.setup(with: viewModels, and: self)
        }
    }
    
    var mainView: FeedView {
        guard let view = self.view as? FeedView else {
            fatalError("View is not of type FeedView!")
        }
        return view
    }
    
    private var baseNumberOfNews: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Fast News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchFeed(numberOfNews: baseNumberOfNews)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let hotNewsViewModel = sender as? HotNewsViewModel else { return }
        guard let detailViewController = segue.destination as? FeedDetailsViewController else { return }
        
        detailViewController.hotNewsViewModel = hotNewsViewModel
    }
    
    private func fetchFeed(numberOfNews: Int) {
        HotNewsProvider.shared.hotNews(kLimitValue: numberOfNews.description) { (completion) in
            do {
                let hotNews = try completion()
                
                self.hotNews = hotNews
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getNumberOfNews() -> Int {
        baseNumberOfNews += 5
        return baseNumberOfNews
    }
}

extension FeedViewController: FeedViewDelegate {
    func didGetInTheBottom() {
        fetchFeed(numberOfNews: self.getNumberOfNews())
    }
    
    func didTouch(cell: FeedCell, indexPath: IndexPath) {
        self.performSegue(withIdentifier: kToDetails, sender: self.mainView.viewModels[indexPath.row])
    }
}
