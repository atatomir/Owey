//
//  TransactionData.swift
//  Owey
//
//  Created by Alex Tatomir on 19/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import Foundation

struct TransactionData {
    enum Kind: String {
        case to = "To"
        case from = "From"
        
        func inverse() -> Kind {
            if self == .to {
                return .from
            } else {
                return .to
            }
        }
    }
    
    var currency: Currency
    var value: Double
    var note: String
    var date: Date
    var kind: Kind
    
    func toTransaction(owner: Friend) -> Transaction {
        let transaction = ModelManager.newTransaction()
        transaction.currency = self.currency.rawValue
        transaction.date = self.date
        transaction.note = self.note
        transaction.value = self.value * (self.kind == .to ? 1 : -1)
        transaction.who = owner
        
        return transaction
    }

}
