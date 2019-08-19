//
//  Currency.swift
//  Owey
//
//  Created by Alex Tatomir on 18/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import Foundation
import UIKit

enum Currency: String, CaseIterable {
    case RON = "RON"
    case USD = "$"
    case EUR = "€"
    case GBP = "£"
    
    static func getIndex(_ currency: Currency) -> Int {
        return Currency.allCases.firstIndex(of: currency)!
    }
}

struct CurrencyValue {
    var currency: Currency = .USD
    var value: Double = 0.00
}
