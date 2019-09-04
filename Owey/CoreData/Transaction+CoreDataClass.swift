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
    
    func reversedTransaction() -> Transaction {
        let transaction = ModelManager.newTransaction()
        transaction.currency = self.currency
        transaction.value = -self.value
        transaction.date = Date()
        transaction.note = "Settle \"" + self.note + "\""
        transaction.who = self.who
        
        return transaction
    }
    
    @objc var headerStringDate: String {
        return date.toString(format: "dd MMMM yyyy")
    }
}
