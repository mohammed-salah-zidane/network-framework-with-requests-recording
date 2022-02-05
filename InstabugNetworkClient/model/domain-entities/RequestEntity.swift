//
//  RequestEntity.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Salah on 04/02/2022.
//

import Foundation

public class RequestEntity: DomainBaseEntity {
    public var method: String?
    public var url: URL?
    public var payload: Data?
    
    public init(method: String? = nil, url: URL? = nil, payload: Data? = nil) {
        self.method = method
        self.url = url
        self.payload = payload
    }
}
