//
//  LoginInfo+CoreDataProperties.swift
//  ChargePark
//
//  Created by apple on 06/11/21.
//
//

import Foundation
import CoreData


extension LoginInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoginInfo> {
        return NSFetchRequest<LoginInfo>(entityName: "LoginInfo")
    }

    @NSManaged public var data: NSObject?

}
