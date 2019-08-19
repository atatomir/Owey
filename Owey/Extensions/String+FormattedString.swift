//
//  FormattedString.swift
//  Owey
//
//  Created by Alex Tatomir on 19/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import Foundation

extension String {
    func formattedString(char replaceWith: Character) -> String {
        var remainingChars = 9
        var result = ""
        
        for char in self {
            if remainingChars == 0 {return result}
            remainingChars -= 1
            
            if !char.isNumber {
                result.append(replaceWith)
                remainingChars = min(remainingChars, 2)
            } else {
                result.append(char)
            }
        }
        
        return result
    }
}
