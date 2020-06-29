//
//  User+CoreDataProperties.swift
//  eComerceApp
//
//  Created by Oswaldo Morales on 6/28/20.
//  Copyright © 2020 Oswaldo Morales. All rights reserved.
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    @NSManaged public var user: String?
    @NSManaged public var birthdate: String?
    @NSManaged public var password: String?
    @NSManaged public var avatar: Data?

}


