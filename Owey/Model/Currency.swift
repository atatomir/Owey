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
    case USD = "US$"
    case EUR = "€"
    case GBP = "£"
}

struct CurrencyValue {
    var currency: Currency = .USD
    var value: Float = 0.00
}