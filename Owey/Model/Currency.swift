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
    case USD = "$"
    case EUR = "€"
    case GBP = "£"
    case RON = "RON"
    case RUB = "₽"
    case CHF = "CHF"
    case TRY = "₺"
    
    static func getIndex(_ currency: Currency) -> Int {
        return Currency.allCases.firstIndex(of: currency)!
    }
    
    func name() -> String {
        switch self {
        case .USD:
            return "United States Dollar"
        case .EUR:
            return "Euro"
        case .GBP:
            return "British Pound"
        case .RON:
            return "Romanian Leu"
        case .RUB:
            return "Russian Ruble"
        case .CHF:
            return "Swiss Franc"
        case .TRY:
            return "Turkish Lira"
        @unknown default:
            return "Unknown"
        }
    }
}

struct CurrencyValue {
    var currency: Currency = .USD
    var value: Double = 0.00
}
