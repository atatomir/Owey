//
//  Friend+CoreDataProperties.swift
//  Owey
//
//  Created by Alex Tatomir on 18/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var name: String
    @NSManaged public var picture: NSObject
    @NSManaged public var transactions: NSSet

}

// MARK: Generated accessors for transactions
extension Friend {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Friend)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Friend)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
