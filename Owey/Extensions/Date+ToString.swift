//
//  Date+ToString.swift
//  Owey
//
//  Created by Alex Tatomir on 04/09/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import Foundation

extension Date {
    func toString(format: String = "dd MM yyyy HH:mm") -> String {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = format
            return formatter
        }()
        
        return formatter.string(from: self)
    }
    
    
    
}


