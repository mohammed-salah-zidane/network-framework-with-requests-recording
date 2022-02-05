//
//  ResponseEntity.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Salah on 04/02/2022.
//

import Foundation

public class ResponseEntity: DomainBaseEntity {
    public var error: ErrorEntity?
    public var success: SuccessEntity?
    
    public init(error: ErrorEntity?, success: SuccessEntity?) {
        self.error = error
        self.success = success
    }
}
