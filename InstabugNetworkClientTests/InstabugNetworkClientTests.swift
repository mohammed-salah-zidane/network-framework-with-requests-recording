//
//  InstabugNetworkClientTests.swift
//  InstabugNetworkClientTests
//
//  Created by Yousef Hamza on 1/13/21.
//

import XCTest
@testable import InstabugNetworkClient

class InstabugNetworkClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        
    }
    
    //MARK:- Test the execution of requests,
    func testGetRequestExecution() throws {
        var payload: Data?
        let expectation = expectation(description: "get request execution")
        NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
            if data == nil {
                XCTFail()
            }
            payload = data
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertFalse(payload == nil,"payload is not nil")
    }
    
    func testDeleteRequestExecution() throws {
        var payload: Data?
        let expectation = expectation(description: "delete request execution")
        NetworkClient.shared.delete(URL(string: "https://httpbin.org/delete")!) { data in
            if data == nil {
                XCTFail()
            }
            payload = data
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(payload != nil,"payload is not nil")
    }
    
    func testPostRequestExecution() throws {
        var payload: Data?
        let expectation = expectation(description: "post request execution")
        NetworkClient.shared.post(URL(string: "https://httpbin.org/post")!, payload: nil) { data in
            if data == nil {
                XCTFail()
            }
            payload = data
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(payload,"payload not nil")
    }
    
    //MARK:- Test the recording and loading of network requests.
    func testRecordingAndLoadingRequests() throws {
        var numberOfRequests = 0
        let expectation = expectation(description: "recorded requests count is not zero")
        NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
            NetworkClient.shared.allNetworkRequests { requests in
                numberOfRequests = requests.count
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertNotEqual(numberOfRequests, 0)
    }
    
    //MARK:- thread safety for the framework
    func testThreadSafetyNetworkClientFramework() throws {
        var numberOfRequests = 0
        let myGroup = DispatchGroup()
        let iterations = 20
        for _ in 1...iterations {
            myGroup.enter()
            NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
                myGroup.leave()
            }
        }
        myGroup.notify(queue: .global()) {
            NetworkClient.shared.allNetworkRequests { requests in
                numberOfRequests = requests.count
                XCTAssertNotEqual(numberOfRequests, 0)
                XCTAssertEqual(numberOfRequests, iterations)
            }
        }
    }
    
    //MARK:- Test respecting the limit of recording.
    func testRecordLimitWhenLoading() throws {
        //Given
        let limit = 100
        NetworkClient.shared.setRecordsLimit(limit)
        
        //When
        var numberOfRequests = 0
        let myGroup = DispatchGroup()
        let iterations = 101
        for _ in 1...iterations {
            myGroup.enter()
            NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
                myGroup.leave()
            }
        }
        
        //Then
        myGroup.notify(queue: .global()) {
            NetworkClient.shared.allNetworkRequests { requests in
                numberOfRequests = requests.count
                XCTAssertNotEqual(numberOfRequests, 0)
                XCTAssertEqual(numberOfRequests, limit)
            }
        }
    }
}
