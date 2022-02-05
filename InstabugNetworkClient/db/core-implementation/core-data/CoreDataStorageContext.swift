//
//  CoreDataStorageContext.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Salah on 04/02/2022.
//

import UIKit
import CoreData

public class CoreDataStorageContext: StorageContext {
    var managedContext: NSManagedObjectContext?
    
    public required init(configuration: ConfigurationType = .basic(identifier: "instabug-db")) {
        switch configuration {
        case .basic:
            initDB(modelName: configuration.identifier(), storeType: .sqLiteStoreType)
        case .inMemory:
            initDB(storeType: .inMemoryStoreType)
        }
    }
    
    private func initDB(modelName: String? = nil, storeType: StoreType) {
        let coordinator = CoreDataStoreCoordinator.persistentStoreCoordinator(modelName: modelName, storeType: storeType)
        self.managedContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.managedContext?.persistentStoreCoordinator = coordinator
    }
}

///MARK:- Operations
extension CoreDataStorageContext {
    
    func create(_ model: NetworkRequestDBEntity.Type) -> NetworkRequestDBEntity? {
        let entityDescription =  NSEntityDescription.entity(forEntityName: String.init(describing: model.self),
                                                            in: managedContext!)
        let entity = NSManagedObject(entity: entityDescription!,
                                     insertInto: managedContext)
        return entity as? NetworkRequestDBEntity
    }
    
    func save() throws {
        try managedContext?.save()
    }
    
    func fetchAll(_ model: NetworkRequestDBEntity.Type, sort: Sort? = nil) throws -> [NetworkRequestDBEntity]?  {
        let fetchRequest = model.fetchRequest()
        if let sort = sort {
            fetchRequest.sortDescriptors = [sort.sortDecriptor()]
        }
        return try managedContext?.fetch(fetchRequest)
    }
    
    func deleteAll(_ model: NetworkRequestDBEntity.Type) throws {
        let entities = try fetchAll(model)
        entities?.forEach({ entity in
            managedContext?.delete(entity)
        })
        try managedContext?.save()
    }
    
    func delete(_ model: NetworkRequestDBEntity) throws {
        managedContext?.delete(model)
    }
    
    func objectWithObjectId(objectId: NSManagedObjectID) -> NetworkRequestDBEntity? {
        do {
            let result = try managedContext!.existingObject(with: objectId)
            return result as? NetworkRequestDBEntity
        } catch {
            print("Failure")
        }
        
        return nil
    }
}
