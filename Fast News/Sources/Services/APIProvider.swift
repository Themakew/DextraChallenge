//
//  APIProvider.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import Alamofire

// MARK: -

class APIProvider {
    
    // MARK: - Constants
    
    private let kBaseURL = "https://www.reddit.com"
    
    // MARK: - Properties -
    
    let sessionManager: Alamofire.SessionManager
    
    // MARK: - Init -
    
    init(configuration: URLSessionConfiguration) {
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    // MARK: - Public Methods -
    
    func baseHeader() -> HTTPHeaders {
        return [:]
    }
}
