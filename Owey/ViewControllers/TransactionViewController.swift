//
//  TransactionViewController.swift
//  Owey
//
//  Created by Alex Tatomir on 18/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import UIKit

protocol TransactionViewControllerDelegate {
    func transactionView(didEndEditing: TransactionData)
}

/* Initialize this view controller by providing a FriendData and a transactionData
 * Result is given back via the delegate's function transactionViewDidEndEditing
 */
class TransactionViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var valueField: UITextField!
    @IBOutlet var picture: RoundedImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!
    @IBOutlet var noteTextField: UITextField!
    
    // MARK: Properties

    var friend: FriendData!
    var transactionData: TransactionData!
    
    private var pickedCurrency: Currency = Currency.allCases[0]
    var delegate: TransactionViewControllerDelegate?
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        valueField.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        initializeFields()
    }
    
    // MARK: Actions
    @IBAction func done(_ sender: UIBarButtonItem) {
        let value = ((valueField.text! as NSString).floatValue) as Float
        
        transactionData = TransactionData(
            currency: pickedCurrency,
            value: value,
            note: noteTextField.text!,
            date: transactionData.date,
            kind: transactionData.kind
        )
        
        delegate?.transactionView(didEndEditing: transactionData)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Private methods
    private func initializeFields() {
        if let friend = friend {
            picture.image = friend.image
            nameLabel.text = transactionData.kind.rawValue + " " + friend.name
            valueField.text =  valueToString(transactionData.value)
            currencyPicker.selectRow(
                Currency.getIndex(transactionData.currency),
                inComponent: 0,
                animated: true
            )
            noteTextField.text = transactionData.note
        }
    }
    
    private func valueToString(_ value: Float) -> String {
        let string = String(value)
        var result = ""
        for char in string {
            if char == "." {
                result.append(",")
            } else {
                result.append(char)
            }
        }
        return result
    }
}

extension TransactionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let text = textField.text ?? ""
        let nsText = text as NSString
        let modText = nsText.replacingCharacters(in: range, with: string)
        
        let digits = modText.filter({ $0.isNumber })
        let postDigits = modText.drop(while: { $0 != "," })
        let commas = modText.filter({ $0 == "," })
        
        if digits.count + commas.count != modText.count {return false}
        if commas.count > 1 {return false}
        if postDigits.count > 3 {return false}
        if digits.count > 9 {return false}
        
        return true
    }
    
}

extension TransactionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Currency.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Currency.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedCurrency = Currency.allCases[row]
    }
}
