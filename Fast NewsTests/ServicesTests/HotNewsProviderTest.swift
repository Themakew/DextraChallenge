//
//  HotNewsProvider.swift
//  Fast NewsTests
//
//  Created by Foton on 20/09/20.
//  Copyright © 2020 Lucas Moreton. All rights reserved.
//

import XCTest
@testable import Fast_News

// MARK: -

class HotNewsProviderTest: XCTestCase {
    
    // MARK: - Properties -
    
    private var alamofire: APIProvider?
    private var hotNewsProvider: HotNewsProvider?
    
    // MARK: - Constants -
    
    private let kTimeout = 30
    private let configuration = URLSessionConfiguration.default
    
    // MARK: - Override Methods -
    
    override func setUp() {
        super.setUp()
        
        configuration.timeoutIntervalForRequest = TimeInterval(kTimeout)
        configuration.timeoutIntervalForResource = TimeInterval(kTimeout)
        alamofire = APIProvider(configuration: configuration)
        hotNewsProvider = HotNewsProvider.shared
    }
    
    override func tearDown() {
        alamofire = nil
        hotNewsProvider = nil
        super.tearDown()
    }
    
    // MARK: - Public Methods -
    
    func testNotNilHotNewsAPIRequest() throws {
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
    
    func testWrongEndPointHotNewsAPIRequest() throws {
        let requestExpectation = expectation(description: "Request should finish")

        hotNewsProvider?.hotNews(requestString: EndPoint.kBaseURL.path + EndPoint.kCommentsEndpoint(id: "").path, completion: { (response) in
            do {
                _ = try response()
            } catch {
                XCTAssertTrue(error.localizedDescription == "unsupported URL")
            }
            requestExpectation.fulfill()
        })

        self.wait(for: [requestExpectation], timeout: 30.0)
    }
    
    func testInvalidURLHotNewsAPIRequest() throws {
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
    
    func testNotNilHotCommentsAPIRequest() throws {
        let requestExpectation = expectation(description: "Request should finish")
        var id: String = ""
        
        hotNewsProvider?.hotNews(requestString: EndPoint.kBaseURL.path + EndPoint.kHotNewsEndpoint.path, completion: { (response) in
            do {
                let responseRequest: [HotNews] = try response()
                id = responseRequest[0].id ?? ""
            } catch {
                XCTFail("TestNotNilHotNewsAPIRequest.")
            }
        })
        
        hotNewsProvider?.hotNewsComments(requestString: EndPoint.kBaseURL.path + EndPoint.kCommentsEndpoint(id: id).path, completion: { (response) in
            do {
                let responseRequest: [Comment] = try response()
                XCTAssertNotNil(responseRequest)
            } catch {
                XCTFail("TestNotNilHotNewsRequest.")
            }
            requestExpectation.fulfill()
        })
        
        self.wait(for: [requestExpectation], timeout: 60.0)
    }
    
    func testWrongEndPointHotCommentAPIRequest() throws {
        let requestExpectation = expectation(description: "Request should finish")
        
        hotNewsProvider?.hotNewsComments(requestString: EndPoint.kBaseURL.path + EndPoint.kCommentsEndpoint(id: "").path, completion: { (response) in
            do {
                _ = try response()
            } catch {
                XCTAssertTrue(error.localizedDescription == "unsupported URL")
            }
            requestExpectation.fulfill()
        })
        
        self.wait(for: [requestExpectation], timeout: 30.0)
    }
    
    func testInvalidURLHotCommentAPIRequest() throws {
        let requestExpectation = expectation(description: "Request should finish")
        
        hotNewsProvider?.hotNewsComments(requestString: "Invalid URL", completion: { (response) in
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
