//
//  Transaction+CoreDataProperties.swift
//  Owey
//
//  Created by Alex Tatomir on 03/09/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var currency: String
    @NSManaged public var date: Date
    @NSManaged public var note: String
    @NSManaged public var value: Double
    @NSManaged public var who: Friend

}
