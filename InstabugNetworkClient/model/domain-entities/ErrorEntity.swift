//
//  ErrorEntity.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Salah on 04/02/2022.
//

import Foundation

public class ErrorEntity: DomainBaseEntity {
    public var errorDomain: String?
    public var errorCode: String
    
    public init(errorDomain: String?, errorCode: Int) {
        self.errorCode = "\(errorCode)"
        self.errorDomain = errorDomain
    }
}
