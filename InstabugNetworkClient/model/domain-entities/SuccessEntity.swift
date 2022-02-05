//
//  SuccessEntity.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Salah on 04/02/2022.
//

import Foundation

public class SuccessEntity: DomainBaseEntity {
    public var statusCode: String?
    public var payload: Data?
 
    public init(statusCode: Int, payload: Data?) {
        self.statusCode = "\(statusCode)"
        self.payload = payload
    }
}
