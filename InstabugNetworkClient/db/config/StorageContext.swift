//
//  StorageContext.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Salah on 04/02/2022.
//

import Foundation
import CoreData

protocol StorageContext {
    var managedContext: NSManagedObjectContext? {get set}

    func create(_ model: NetworkRequestDBEntity.Type) -> NetworkRequestDBEntity?

    func save() throws
    
    func deleteAll(_ model: NetworkRequestDBEntity.Type) throws
    
    func fetchAll(_ model: NetworkRequestDBEntity.Type) throws -> [NetworkRequestDBEntity]?
}

extension StorageContext {
    func objectWithObjectId(objectId: NSManagedObjectID) -> NetworkRequestDBEntity? {
        return nil
    }
}
