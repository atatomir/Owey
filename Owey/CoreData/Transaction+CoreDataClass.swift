//
//  Transaction+CoreDataClass.swift
//  Owey
//
//  Created by Alex Tatomir on 18/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//
//

/* to = +, from = -
 * (+) = gave but will receive
 * (-)
 */

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {

    func toTransactionData() -> TransactionData {
        guard let actualCurrency = Currency(rawValue: currency) else {
            fatalError("Currency not found")
        }

        return TransactionData(
            currency: actualCurrency,
            value: abs(value),
            note: note,
            date: date,
            kind: (value > 0 ? .to : .from)
        )
    }
    
    @objc var headerStringDate: String {
        return date.toString(format: "dd MMMM yyyy")
    }
}
