//
//  UserEvs+CoreDataProperties.swift
//  ChargePark
//
//  Created by apple on 06/11/21.
//
//

import Foundation
import CoreData


extension UserEvs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEvs> {
        return NSFetchRequest<UserEvs>(entityName: "UserEvs")
    }

    @NSManaged public var data: NSObject?

}
