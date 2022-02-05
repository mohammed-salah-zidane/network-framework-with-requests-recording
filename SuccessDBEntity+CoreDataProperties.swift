//
//  SuccessDBEntity+CoreDataProperties.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Salah on 05/02/2022.
//
//

import Foundation
import CoreData


extension SuccessDBEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SuccessDBEntity> {
        return NSFetchRequest<SuccessDBEntity>(entityName: "SuccessDBEntity")
    }

    @NSManaged public var payload: Data?
    @NSManaged public var statusCode: String?

}

extension SuccessDBEntity : Identifiable {

}
