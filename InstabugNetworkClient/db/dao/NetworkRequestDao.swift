//
//  BaseDao.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Salah on 04/02/2022.
//

import UIKit

class NetworkRequestDao {
    
    private var storageContext: StorageContext
        
    required init(storageContext: StorageContext) {
        self.storageContext = storageContext
    }
    
    func save(object: NetworkRequest) {
        var dbEntity: NetworkRequestDBEntity?
        if object.objectID != nil {
            dbEntity = storageContext.objectWithObjectId(objectId: object.objectID!)
        } else {
            dbEntity = storageContext.create(NetworkRequestDBEntity.self)
        }
        
        Mapper.mapToDB(from: object, target: &dbEntity!, context: storageContext.managedContext!)
        do {
            try storageContext.save()
        }catch {
            print(error.localizedDescription)
        }
    }

    func getExceededRecord(_ recordsLimitCount: Int = 1000) -> NetworkRequestDBEntity?  {
        do {
            let sort = Sort.init(key: "createDate")
            let entites = try storageContext.fetchAll(NetworkRequestDBEntity.self, sort: sort)
            print("entitiescount,",entites?.count, recordsLimitCount)
            guard let entitiesCount = entites?.count, entitiesCount == recordsLimitCount  else {
                return nil
            }
            guard let firstEntity = entites?.first else {
                return nil
            }
            return firstEntity
        }catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func delete(_ entity: NetworkRequestDBEntity?) {
        do {
            guard let entity = entity else {
                return
            }
            try storageContext.delete(entity)
            try storageContext.save()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func reset()  {
        do {
            try storageContext.deleteAll(NetworkRequestDBEntity.self)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAll(_ sort: Sort? = nil) -> [NetworkRequest] {
        do {
            var requests = [NetworkRequest]()
            let sort = Sort.init(key: "createDate")
            let entites = try storageContext.fetchAll(NetworkRequestDBEntity.self, sort: sort)
            entites?.forEach({ entity in
                var request = NetworkRequest()
                Mapper.mapToDomain(from: entity, target: &request)
                requests.append(request)
            })
            return requests
        }catch {
            print(error.localizedDescription)
            return []
        }
    }
}
