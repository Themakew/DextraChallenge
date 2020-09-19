//
//  FeedDetailsViewController.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import UIKit

// MARK: -

class FeedDetailsViewController: UIViewController {
    
    // MARK: - Properties -
    
    var hotNewsViewModel: HotNewsViewModel?
    
    private var viewModels: [TypeProtocol] = [TypeProtocol]()
    
    var comments: [Comment] = [Comment]() {
        didSet {
            if let hotNews = hotNewsViewModel {
                viewModels.append(hotNews)
            }
            
            _ = comments.map { (comment) in
                viewModels.append(CommentViewModel(comment: comment))
            }
            
            self.mainView.viewModels = self.viewModels
        }
    }
    
    var mainView: FeedDetailsView {
        guard let view = self.view as? FeedDetailsView else {
            fatalError("View is not of type FeedDetailsView!")
        }
        return view
    }
    
    // MARK: - Override Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        fetchNewsDetail()
        mainView.setup(delegate: self)
    }
    
    // MARK: - Private Methods -
    
    private func fetchNewsDetail() {
        HotNewsProvider.shared.hotNewsComments(id: hotNewsViewModel?.id ?? "") { [weak self] (completion) in
            guard let self = self else { return }
            
            do {
                let comments = try completion()
                
                self.comments = comments
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - FeedViewDelegate -

extension FeedDetailsViewController: FeedViewDelegate {
    func didTouch(cell: FeedCell, indexPath: IndexPath) {
        guard self.mainView.viewModels[indexPath.row].type == .hotNews,
            let viewModel = self.mainView.viewModels[indexPath.row] as? HotNewsViewModel else {
                return
        }
        
        if let url = URL(string: viewModel.url) {
            UIApplication.shared.open(url)
        }
    }
}
