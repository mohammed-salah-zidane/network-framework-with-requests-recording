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
            self.recordRequest(
                urlRequest: urlRequest,
                data: data,
                response: response as? HTTPURLResponse,
                error: error as NSError?
            )
            
            self.concurrentQueue.async {
                completionHandler(data)
            }
        }
    }
}

// MARK: Network recording
extension NetworkClient {
    public func enableRecording(with context: CoreDataStorageContext) {
        DBManager.setup(storageContext: context)
        recordingEnabled = true
        DBManager.shared.networkRequestDao.reset()
    }
    
    public func allNetworkRequests(
        _ completionHandler: @escaping ([NetworkRequest]) -> Void
    ) {
        guard recordingEnabled else {
            fatalError("You must call enableRecording function to configure the StoreContext before accessing any dao")
        }
        
        concurrentQueue.async {
            let requests = DBManager.shared.networkRequestDao.fetchAll()
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
        self.concurrentQueue.async(flags: .barrier) {
            let networkRequest = NetworkRequest.create(urlRequest: urlRequest, data: data, response: response, error: error)
            DBManager.shared.networkRequestDao.save(object: networkRequest)
        }
    }
}
