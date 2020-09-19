//
//  CommentCell.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import UIKit

// MARK: -

class CommentCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var upsLabel: UILabel!
    @IBOutlet weak var downsLabel: UILabel!
    
    // MARK: - Override Methods -
    
    override func prepareForReuse() {
        authorLabel.text = nil
        createdAtLabel.text = nil
        commentLabel.text = nil
        upsLabel.text = nil
        downsLabel.text = nil
    }
    
    // MARK: - Public Methods
    
    func setup(viewModel: TypeProtocol) {
        guard let commentViewModel = viewModel as? CommentViewModel else { return }
        authorLabel.text = commentViewModel.author
        createdAtLabel.text = commentViewModel.createdAt
        commentLabel.text = commentViewModel.body
        upsLabel.text = commentViewModel.ups
        downsLabel.text = commentViewModel.downs
    }
}
