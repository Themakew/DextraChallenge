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
typealias HotNewsImageCallBack = ( () throws -> Data) -> Void

// MARK: -

class HotNewsProvider {
    
    // MARK: - Properties -
    
    // Hot News key/value parameters
    private let kLimitKey = "limit"
    private let kLimitValue = 5
    private let kAfterKey = "after"
    private var kAfterValue = ""
    private let kTimeout = 30
    private let alamofire: APIProvider
    
    // MARK: - Singleton -
    
    static let shared: HotNewsProvider = HotNewsProvider(configuration: URLSessionConfiguration.default)
    
    // MARK: - Init -
    
    init(configuration: URLSessionConfiguration) {
        configuration.timeoutIntervalForRequest = TimeInterval(kTimeout)
        configuration.timeoutIntervalForResource = TimeInterval(kTimeout)
        
        alamofire = APIProvider(configuration: configuration)
    }
    
    // MARK: - Public Methods -
    
    func hotNews(requestString: String, completion: @escaping HotNewsCallback) {
        let parameters: Parameters = [ kLimitKey: kLimitValue,
                                       kAfterKey: kAfterValue ]
        
        do {
            let requestURL = try requestString.asURL()
            
            let headers: HTTPHeaders = alamofire.baseHeader()
            
            alamofire.sessionManager.request(requestURL, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    
                    guard let hotNewsDict = response.result.value as? [String: AnyObject],
                          let hotNewsAfterString = hotNewsDict["data"]?["after"] as? String,
                          let dictArray = hotNewsDict["data"]?["children"] as? [[String: AnyObject]] else {
                        completion { return [HotNews]() }
                        return
                    }
                    
                    self.kAfterValue = hotNewsAfterString
                    
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
    
    func hotNewsComments(requestString: String, completion: @escaping HotNewsCommentsCallback) {
        
        do {
            let requestURL = try requestString.asURL()
            
            let headers: HTTPHeaders = alamofire.baseHeader()
            
            alamofire.sessionManager.request(requestURL, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
                
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
    
    func getHotNewsImage(url: String, completion: @escaping HotNewsImageCallBack) {
        do {
            let requestURL = try url.asURL()
            
            alamofire.sessionManager.request(requestURL).responseData(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if let data = response.data {
                        completion { return data }
                    } else {
                        completion { return NSData() as Data }
                    }
                case .failure(let error):
                    completion { throw error }
                }
            })
        } catch {
            completion { throw error }
        }
    }
}
