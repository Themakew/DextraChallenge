//
//  HotNewsProvider.swift
//  Fast NewsTests
//
//  Created by Foton on 20/09/20.
//  Copyright © 2020 Lucas Moreton. All rights reserved.
//

import XCTest
@testable import Fast_News

class HotNewsProviderTest: XCTestCase {
    
    let configuration = URLSessionConfiguration.default
    var alamofire: APIProvider?
    var hotNewsProvider: HotNewsProvider?
    private let kTimeout = 30
    
    override func setUp() {
        super.setUp()
        
        configuration.timeoutIntervalForRequest = TimeInterval(kTimeout)
        configuration.timeoutIntervalForResource = TimeInterval(kTimeout)
        alamofire = APIProvider(configuration: configuration)
        hotNewsProvider = HotNewsProvider.shared
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNotNilHotNewsRequest() {
        let requestExpectation = expectation(description: "Request should finish")
        
        hotNewsProvider?.hotNews(requestString: EndPoint.kBaseURL.path + EndPoint.kHotNewsEndpoint.path, completion: { (response) in
            do {
                let responseRequest: [HotNews] = try response()
                XCTAssertNotNil(responseRequest)
            } catch {
                XCTFail("TestNotNilHotNewsRequest.")
            }
            requestExpectation.fulfill()
        })
        
        self.wait(for: [requestExpectation], timeout: 30.0)
    }
    
    func testWrongEndPointHotNewsRequest() {
        let requestExpectation = expectation(description: "Request should finish")
        
        hotNewsProvider?.hotNews(requestString: EndPoint.kBaseURL.path + EndPoint.kCommentsEndpoint(id: "0").path, completion: { (response) in
            do {
                let responseRequest: [HotNews] = try response()
                XCTAssertEqual(responseRequest.count, 0)
            } catch {
                XCTFail("TestNotNilHotNewsRequest.")
            }
            requestExpectation.fulfill()
        })
        
        self.wait(for: [requestExpectation], timeout: 30.0)
    }
    
    func testInvalidURLHotNewsRequest() {
        let requestExpectation = expectation(description: "Request should finish")

        hotNewsProvider?.hotNews(requestString: "Invalid URL", completion: { (response) in
            do {
                _ = try response()
            } catch {
                XCTAssertTrue(error.localizedDescription == "URL is not valid: Invalid URL")
            }
            requestExpectation.fulfill()
        })

        self.wait(for: [requestExpectation], timeout: 30.0)
    }
}
