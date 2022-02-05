//
//  StorageContext.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Salah on 04/02/2022.
//

import Foundation
import CoreData

protocol StorageContext: StoregeContextCoreDataProtcol {
    
    func create(_ model: NetworkRequestDBEntity.Type) -> NetworkRequestDBEntity?

    func save() throws
    
    func deleteAll(_ model: NetworkRequestDBEntity.Type) throws
    
    func fetchAll(_ model: NetworkRequestDBEntity.Type) throws -> [NetworkRequestDBEntity]?
}

protocol StoregeContextCoreDataProtcol {
    var managedContext: NSManagedObjectContext? {get set}
}

extension StoregeContextCoreDataProtcol {
    func objectWithObjectId(objectId: NSManagedObjectID) -> NetworkRequestDBEntity? {
        return nil
    }
}
