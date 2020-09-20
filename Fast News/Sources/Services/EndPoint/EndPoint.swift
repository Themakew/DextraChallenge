//
//  EndPoint.swift
//  Fast News
//
//  Created by Ruyther on 18/09/20.
//  Copyright © 2020 Lucas Moreton. All rights reserved.
//

import Foundation

// MARK: -

enum EndPoint {
    
    case kHotNewsEndpoint
    case kCommentsEndpoint(id: String)
    case kBaseURL
    
    var path: String {
        switch self {
        case .kHotNewsEndpoint:
            return "/r/ios/hot/.json"
        case .kCommentsEndpoint(let id):
            return String(format: "/r/ios/comments/%@.json", id)
        case .kBaseURL:
            return "https://www.reddit.com"
        }
    }
}
