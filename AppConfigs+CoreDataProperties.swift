//
//  AppConfigs+CoreDataProperties.swift
//  ChargePark
//
//  Created by apple on 06/11/21.
//
//

import Foundation
import CoreData


extension AppConfigs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppConfigs> {
        return NSFetchRequest<AppConfigs>(entityName: "AppConfigs")
    }

    @NSManaged public var data: NSObject?

}
