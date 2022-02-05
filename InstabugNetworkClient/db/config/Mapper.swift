//
//  Mapper.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Salah on 04/02/2022.
//

import UIKit
import CoreData

class Mapper {
    
    class func mapToDomain(from dbEntity: NetworkRequestDBEntity, target domainEntity: inout NetworkRequest) {
        domainEntity.response?.error?.errorCode = dbEntity.response?.error?.errorCode ?? "0"
        domainEntity.response?.error?.errorDomain = dbEntity.response?.error?.errorDomain
        domainEntity.response?.error?.objectID = dbEntity.response?.error?.objectID
        domainEntity.response?.success?.payload = dbEntity.response?.success?.payload
        domainEntity.response?.success?.statusCode = dbEntity.response?.success?.statusCode
        domainEntity.response?.success?.objectID = dbEntity.response?.success?.objectID
        domainEntity.response?.objectID = dbEntity.response?.objectID
        domainEntity.request?.payload = dbEntity.request?.payload
        domainEntity.request?.url = dbEntity.request?.url
        domainEntity.request?.method = dbEntity.request?.method
        domainEntity.request?.objectID = dbEntity.request?.objectID
        domainEntity.createDate = dbEntity.createDate
        domainEntity.objectID = dbEntity.objectID
    }

    class func mapToDB(from domainEntity: NetworkRequest, target dbEntity: inout NetworkRequestDBEntity, context: NSManagedObjectContext) {
        let error = ErrorDBEntity(context: context)
        error.errorCode = domainEntity.response?.error?.errorCode
        error.errorDomain = domainEntity.response?.error?.errorDomain
        let success = SuccessDBEntity(context: context)
        success.payload = domainEntity.response?.success?.payload
        success.statusCode = domainEntity.response?.success?.statusCode
        let response = ResponseDBEntity(context: context)
        response.success = success
        response.error = error
        let request = RequestDBEntity(context: context)
        request.payload = domainEntity.request?.payload
        request.url = domainEntity.request?.url
        request.method = domainEntity.request?.method
        dbEntity.createDate = domainEntity.createDate
        dbEntity.response = response
        dbEntity.request = request
    }
}
