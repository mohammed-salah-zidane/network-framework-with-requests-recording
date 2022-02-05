//
//  ResponseDBEntity+CoreDataProperties.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Salah on 04/02/2022.
//
//

import Foundation
import CoreData


extension ResponseDBEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ResponseDBEntity> {
        return NSFetchRequest<ResponseDBEntity>(entityName: "ResponseDBEntity")
    }

    @NSManaged public var error: ErrorDBEntity?
    @NSManaged public var success: SuccessDBEntity?

}

extension ResponseDBEntity : Identifiable {

}
