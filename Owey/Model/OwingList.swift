//
//  OwingList.swift
//  Owey
//
//  Created by Alex Tatomir on 19/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import Foundation
import UIKit

class OwingList {
    static let eps: Double = 0.01
    
    var owing: [Currency: Double] = [:]
    var owed: [Currency: Double] = [:]
    
    init(transactions: [Transaction]) {
        for currency in Currency.allCases {
            owing[currency] = 0
            owed[currency] = 0
        }
        
        for trans in transactions {
            guard let currency = Currency(rawValue: trans.currency) else {
                fatalError("Unrecognized currency in OwingList initializer")
            }
            
            if trans.value < 0 {
                owing[currency]! -= trans.value
            } else {
                owed[currency]! += trans.value
            }
        }
        
        for currency in Currency.allCases {
            let minValue = min(owing[currency]!, owed[currency]!)
            owing[currency]! -= minValue
            owed[currency]! -= minValue
        }
    }
    
    convenience init() {
        ModelManager.refetchData(.transaction, forFriend: nil)
        self.init(transactions: ModelManager.fetchedTransactions())
    }
    
    convenience init(for friend: Friend) {
        ModelManager.refetchData(.transaction, forFriend: friend)
        self.init(transactions: ModelManager.fetchedTransactions())
    }
    
    func isEmptyOwing() -> Bool {
        for currency in Currency.allCases {
            if owing[currency]! >= OwingList.eps {return false}
        }
        
        return true
    }
    
    func isEmptyOwed() -> Bool {
        for currency in Currency.allCases {
            if owed[currency]! >= OwingList.eps {return false}
        }
        
        return true
    }
    
    func isEmpty() -> Bool {
        return isEmptyOwed() || isEmptyOwing()
    }
    
    func allTexts() -> (String?, String?, String?) {
        var owingText: String?
        var owedText: String?
        var settledText: String?
        var first: Bool = true
        
        if !isEmptyOwing() {
            owingText = "You owe "
            first = true
            
            for currency in Currency.allCases {
                let value = owing[currency]!
                if  value > OwingList.eps {
                    if !first {owingText! +=  " + "}
                    owingText! += currency.rawValue + String(value).formattedString(char: ",")
                    first = false
                }
            }
        }
        
        if !isEmptyOwed() {
            owedText = "You are owed "
            first = true
            
            for currency in Currency.allCases {
                let value = owed[currency]!
                if  value > OwingList.eps {
                    if !first {owedText! +=  " + "}
                    owedText! += currency.rawValue + String(value).formattedString(char: ",")
                    first = false
                }
            }
        }
        
        if owingText == nil && owedText == nil{
            settledText = "Settled up"
        }
        
        return (owingText, owedText, settledText)
    }
}
