//
//  HotNewsViewModel.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import Foundation
import UIKit

// MARK: -

class HotNewsViewModel {
    
    // MARK: - Properties -
    
    var id: String
    var author: String
    var createdAt: String
    var title: String
    var comments: String
    var up: String
    var down: String
    var url: String
    var image: UIImage?
    var thumbnailImageUrl: String
    
    // MARK: - Init -
    
    init(hotNews: HotNews) {
        id = hotNews.id ?? ""
        author = hotNews.authorFullname ?? ""
        createdAt = hotNews.created?.createdAt ?? ""
        title = hotNews.title ?? ""
        comments = hotNews.numComments?.toString ?? ""
        up = hotNews.ups?.toString ?? ""
        down = hotNews.downs?.toString ?? ""
        url = hotNews.url ?? ""
        thumbnailImageUrl = hotNews.preview?.images?.first?.source?.url?.htmlDecoded ?? ""
    }
}

// MARK: - Extension -

extension HotNewsViewModel: TypeProtocol {
    var type: Type { return .hotNews }
}
