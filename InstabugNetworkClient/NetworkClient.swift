//
//  NetworkClient.swift
//  InstabugNetworkClient
//
//  Created by Yousef Hamza on 1/13/21.
//

import Foundation

public class NetworkClient {
    public static var shared = NetworkClient()

    // MARK: Network requests
    public func get(_ url: URL, payload: Any?=nil) {
        fatalError("Not implemented")
    }

    public func post(_ url: URL, payload: Any?=nil) {
        fatalError("Not implemented")
    }

    public func put(_ url: URL, payload: Any?=nil) {
        fatalError("Not implemented")
    }

    public func delete(_ url: URL, payload: Any?=nil) {
        fatalError("Not implemented")
    }

    // MARK: Network recording
    #warning("Replace Any with an appropriate type")
    public func allNetworkRequests() -> Any {
        fatalError("Not implemented")
    }
}
