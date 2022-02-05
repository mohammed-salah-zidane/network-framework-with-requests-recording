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
        NetworkClient.shared.enableRecording(with: CoreDataStorageContext(), withRecordsLimit: 1000)
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
        NetworkClient.shared.enableRecording(with: CoreDataStorageContext(), withRecordsLimit: 1000)
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
        NetworkClient.shared.enableRecording(with: CoreDataStorageContext(), withRecordsLimit: 1000)
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
        NetworkClient.shared.enableRecording(with: CoreDataStorageContext(), withRecordsLimit: 1000)

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
    
    //MARK:- Test respecting the limit of recording and also thread safe.
    func testRecordLimitWhenLoading() throws {
        //Given
        let limit = 2
        NetworkClient.shared.setRecordsLimit(limit)

        let expectation = expectation(description: "record limited")

        //When
        var numberOfRequests = 0
        
        NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
            if data == nil {
                XCTFail()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1,  execute: {
            NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
                if data == nil {
                    XCTFail()
                }
            }
        })
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2,  execute: {
            NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
                if data == nil {
                    XCTFail()
                }
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            NetworkClient.shared.allNetworkRequests { requests in
                numberOfRequests = requests.count
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10)
        //Then
        XCTAssertNotEqual(numberOfRequests, 0)
        XCTAssertEqual(numberOfRequests, limit)
    }
}
