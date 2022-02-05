//
//  Sort.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Salah on 05/02/2022.
//

import Foundation
import CoreData

/* Query options */
public struct Sort {
    var key: String
    var ascending: Bool = true
}

extension Sort {
    func sortDecriptor() -> NSSortDescriptor  {
        NSSortDescriptor.init(key: key, ascending: ascending)
    }
}
