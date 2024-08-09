//
//  AccountDetails+CoreDataProperties.swift
//  PasswordManager
//
//  Created by Darshan on 09/08/24.
//
//

import Foundation
import CoreData


extension AccountDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountDetails> {
        return NSFetchRequest<AccountDetails>(entityName: "AccountDetails")
    }

    @NSManaged public var accountName: String?
    @NSManaged public var id: String?
    @NSManaged public var password: String?
    @NSManaged public var username_email: String?

}

extension AccountDetails : Identifiable {

}
