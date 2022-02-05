//
//  NetworkClient.swift
//  InstabugNetworkClient
//
//  Created by Yousef Hamza on 1/13/21.
//

import Foundation

public class NetworkClient {
    public static let shared = NetworkClient()
    
    private init() {}
    
    private var recordingEnabled: Bool = false
    
    //Concurrent Queueu for thread safe operations
    private let concurrentQueue = DispatchQueue(label: "InstabugConcurrentQueue", attributes: .concurrent)
    
    private var networkRequestDB: NetworkRequestDao?
    
    private var recordsLimitCount: Int = 1000
    
    // MARK: Network requests
    public func get(
        _ url: URL,
        completionHandler: @escaping (Data?) -> Void
    ) {
        executeRequest(url, method: "GET", payload: nil, completionHandler: completionHandler)
    }
    
    public func post(
        _ url: URL,
        payload: Data? = nil,
        completionHandler: @escaping (Data?) -> Void
    ) {
        executeRequest(url, method: "POST", payload: payload, completionHandler: completionHandler)
    }
    
    public func put(
        _ url: URL,
        payload: Data? = nil ,
        completionHandler: @escaping (Data?) -> Void
    ) {
        executeRequest(url, method: "PUT", payload: payload, completionHandler: completionHandler)
    }
    
    public func delete(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "DELETE", payload: nil, completionHandler: completionHandler)
    }
    
    func executeRequest(
        _ url: URL,
        method: String,
        payload: Data?,
        completionHandler: @escaping (Data?) -> Void
    ) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = payload
        
        URLSession.shared.dataTask(with: urlRequest) {[weak self] data, response, error in
            guard let self = self else {return}
            let myGroup = DispatchGroup()
            myGroup.enter()
            self.validateRecordsLimit {
                myGroup.leave()
            }
            myGroup.notify(queue: .main) {
                self.recordRequest(
                    urlRequest: urlRequest,
                    data: data,
                    response: response as? HTTPURLResponse,
                    error: error as NSError?
                )
                
                self.concurrentQueue.sync {
                    print("back.....")
                    completionHandler(data)
                }
            }
        }.resume()
    }
}

// MARK: Network recording
extension NetworkClient {
    public func enableRecording(with context: CoreDataStorageContext, withRecordsLimit limit: Int) {
        self.concurrentQueue.async(flags: .barrier) {[weak self] in
            self?.recordsLimitCount = limit
            self?.recordingEnabled = true
            self?.networkRequestDB = NetworkRequestDao(storageContext: context)
            self?.networkRequestDB?.reset()
        }
    }
    
    public func resetRecords() {
        self.concurrentQueue.async(flags: .barrier) {[weak self] in
            self?.networkRequestDB?.reset()
        }
    }
    
    public func setRecordsLimit(_ limit: Int) {
        self.concurrentQueue.async(flags: .barrier) {[weak self] in
            self?.recordsLimitCount = limit
        }
    }
    
    public func allNetworkRequests(
        _ completionHandler: @escaping ([NetworkRequest]) -> Void
    ) {
        guard recordingEnabled else {
            fatalError("You must call enableRecording function to configure the StoreContext before accessing any dao")
        }
        
        concurrentQueue.sync { [weak self] in
            guard let self = self else { return }
            guard let requests = self.networkRequestDB?.fetchAll() else { return }
            completionHandler(requests)
        }
    }
    
    func recordRequest(
        urlRequest: URLRequest,
        data: Data?,
        response: HTTPURLResponse?,
        error: NSError?
    ) {
        guard recordingEnabled else {
            return
        }
        //Barrier flag in GrandDispatchQueue to convert all concurrent threads to serial untill complete its block then reverse it to concurrent again
        self.concurrentQueue.async(flags: .barrier) {[weak self] in
            guard let self = self else { return }
            let networkRequest = NetworkRequest.create(urlRequest: urlRequest, data: data, response: response, error: error)
            self.networkRequestDB?.save(object: networkRequest)
            print("recording.....")
        }
        
    }
    
    func validateRecordsLimit(_ completionHandler: @escaping () -> Void) {
        var entity: NetworkRequestDBEntity?
        let group = DispatchGroup()
        group.enter()
        concurrentQueue.sync { [weak self] in
            entity = self?.networkRequestDB?.getExceededRecord(self?.recordsLimitCount ?? 0)
            group.leave()
        }
        
        group.wait()
        
        guard entity != nil else {
            completionHandler()
            return
        }
        
        self.concurrentQueue.async(flags: .barrier) {[weak self] in
            self?.networkRequestDB?.delete(entity)
        }
    }
}
