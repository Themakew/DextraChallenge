//
//  HotNewsProvider.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Type alias

typealias HotNewsCallback = ( () throws -> [HotNews]) -> Void
typealias HotNewsCommentsCallback = ( () throws -> [Comment]) -> Void

class HotNewsProvider {
    
    // MARK: - Properties -
    
    // Hot News key/value parameters
    private let kLimitKey = "limit"
    private let kLimitValue = 5
    private let kAfterKey = "after"
    private let kAfterValue = ""
    
    private let alamofire = APIProvider.shared.sessionManager
    
    // MARK: - Singleton -
    
    static let shared: HotNewsProvider = HotNewsProvider()
    
    // MARK: - Public Methods -
    
    func hotNews(kLimitValue: String, completion: @escaping HotNewsCallback) {
        let requestString = APIProvider.shared.baseURL() + EndPoint.kHotNewsEndpoint.path
        
        let parameters: Parameters = [ kLimitKey: kLimitValue,
                                       kAfterKey: kAfterValue ]
        
        do {
            let requestURL = try requestString.asURL()
            
            let headers: HTTPHeaders = APIProvider.shared.baseHeader()
            
            alamofire.request(requestURL, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    
                    guard let hotNewsDict = response.result.value as? [String: AnyObject],
                          let dictArray = hotNewsDict["data"]?["children"] as? [[String: AnyObject]] else {
                        completion { return [HotNews]() }
                        return
                    }
                    
                    var hotNewsArray: [HotNews] = [HotNews]()
                    
                    for hotNews in dictArray {
                        let data = hotNews["data"]
                        
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: data as Any, options: .prettyPrinted),
                              let hotNews = try? JSONDecoder().decode(HotNews.self, from: jsonData) else {
                            completion { return [HotNews]() }
                            return
                        }
                        
                        hotNewsArray.append(hotNews)
                    }
                    
                    completion { return hotNewsArray }
                case .failure(let error):
                    completion { throw error }
                }
            }
        } catch {
            completion { throw error }
        }
    }
    
    func hotNewsComments(id: String, completion: @escaping HotNewsCommentsCallback) {
        let endpoint = EndPoint.kCommentsEndpoint(id: id).path
        let requestString = APIProvider.shared.baseURL() + endpoint
        
        do {
            let requestURL = try requestString.asURL()
            
            let headers: HTTPHeaders = APIProvider.shared.baseHeader()
            
            alamofire.request(requestURL, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    
                    guard let hotNewsDict = response.result.value as? [[String: AnyObject]],
                        let dictArray = hotNewsDict.last?["data"]?["children"] as? [[String: AnyObject]] else {
                            completion { return [Comment]() }
                            return
                    }
                    
                    var commentsArray: [Comment] = [Comment]()
                    
                    for comment in dictArray {
                        let data = comment["data"]
                        
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: data as Any, options: .prettyPrinted),
                            let comment = try? JSONDecoder().decode(Comment.self, from: jsonData) else {
                                completion { return [Comment]() }
                                return
                        }
                        
                        if !comment.isEmpty() {
                            commentsArray.append(comment)
                        }
                    }
                    
                    completion { return commentsArray }
                case .failure(let error):
                    completion { throw error }
                }
            }
        } catch {
            completion { throw error }
        }
    }
}
