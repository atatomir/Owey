//
//  CurrencyPickerController.swift
//  Owey
//
//  Created by Alex Tatomir on 04/09/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import UIKit

protocol CurrencyPickerControllerDelegate {
    func currecyPicker(didChoose: Currency?)
}

class CurrencyPickerController: UIAlertController {
    
    // MARK: Properties
    var delegate: CurrencyPickerControllerDelegate? = nil
    
    // MARK: Initialization
    convenience init(_ title: String) {
        self.init(title: title, message: nil, preferredStyle: .actionSheet)
        
        for currency in Currency.allCases {
            let action = UIAlertAction(
                title: currency.name() + "(" + currency.rawValue + ")",
                style: .default,
                handler: { _ in
                    self.delegate?.currecyPicker(didChoose: currency)
            }
            )
            
            self.addAction(action)
        }
        
        let action = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: { _ in
                self.delegate?.currecyPicker(didChoose: nil)
        }
        )
        self.addAction(action)
    }

    

}
