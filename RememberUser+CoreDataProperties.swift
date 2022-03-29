//
//  RememberUser+CoreDataProperties.swift
//  ChargePark
//
//  Created by apple on 05/11/21.
//
//

import Foundation
import CoreData


extension RememberUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RememberUser> {
        return NSFetchRequest<RememberUser>(entityName: "RememberUser")
    }

    @NSManaged public var logedIn: Bool

}
