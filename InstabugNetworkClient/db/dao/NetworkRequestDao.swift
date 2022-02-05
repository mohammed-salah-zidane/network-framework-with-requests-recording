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
    
    func reset()  {
        do {
            try storageContext.deleteAll(NetworkRequestDBEntity.self)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAll() -> [NetworkRequest] {
        var requests = [NetworkRequest]()
        do {
            let entites = try storageContext.fetchAll(NetworkRequestDBEntity.self)
            entites?.forEach({ entity in
                var request = NetworkRequest()
                Mapper.mapToDomain(from: entity, target: &request)
                requests.append(request)
            })
        }catch {
            print(error.localizedDescription)
        }
        return requests
    }
}
