//
//  ProfileInfo+CoreDataProperties.swift
//  ChargePark
//
//  Created by apple on 06/11/21.
//
//

import Foundation
import CoreData


extension ProfileInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileInfo> {
        return NSFetchRequest<ProfileInfo>(entityName: "ProfileInfo")
    }

    @NSManaged public var data: NSObject?

}
