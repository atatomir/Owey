//
//  TransactionViewController.swift
//  Owey
//
//  Created by Alex Tatomir on 18/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import UIKit

protocol TransactionViewControllerDelegate {
    // return nil if you want to delete this transaction
    func transactionView(didEndEditing: TransactionData?)
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
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var directionButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    // MARK: Properties
    var friendData: FriendData!
    var transactionData: TransactionData!
    var canBeDeleted: Bool = false
    
    private var pickedCurrency: Currency = Currency.allCases[0]
    var delegate: TransactionViewControllerDelegate?
    
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        valueField.delegate = self
        noteTextField.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        // Initialize
        initializeFields()
        valueField.becomeFirstResponder()
        updateDoneButton()
        updateDeleteButton()
        directionButton.setCornerRadius()
    }
    
    // MARK: Actions
    
    @IBAction func deleteTransaction(_ sender: Any) {
        delegate?.transactionView(didEndEditing: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeDirection(_ sender: UIButton) {
        transactionData.kind = transactionData.kind.inverse()
        directionButton.setTitle(transactionData.kind.rawValue, for: .normal)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        let formatted = valueField.text!.formattedString(char: ".")
        let value = ((formatted as NSString).doubleValue) as Double
        
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
    
    @IBAction func valueChanged(_ sender: UITextField) {
        updateDoneButton()
    }
    
    
    @IBAction func noteChanged(_ sender: UITextField) {
        updateDoneButton()
    }
    
    
    
    // MARK: Private methods
    private func initializeFields() {
        if let friend = friendData, let transactionData = transactionData {
            picture.image = friend.image
            directionButton.setTitle(transactionData.kind.rawValue, for: .normal)
            nameLabel.text = friend.name
            currencyPicker.selectRow(
                Currency.getIndex(transactionData.currency),
                inComponent: 0,
                animated: true
            )
            pickedCurrency = transactionData.currency
            noteTextField.text = transactionData.note
            
            if transactionData.value < 0 {
                valueField.text = ""
            } else {
                valueField.text = String(transactionData.value).formattedString(char: ",")
            }
        } else {
            fatalError("Could not initialize fields in TransactionViewController")
        }
    }
    
    private func updateDoneButton() {
        func shouldBeEnabled() -> Bool {
            guard let valueText = valueField.text,
                let noteText = noteTextField.text,
                let value = Double(valueText.formattedString(char: ".")) else {
                    
                return false
            }
            
            if !valueTextValidation(valueText) { return false }
            if !noteTextValidation(noteText) { return false }
            if value < OwingList.eps { return false }
            if noteText.count == 0 { return false }
            
            return true
        }
        
        doneButton.isEnabled = shouldBeEnabled()
    }

    private func updateDeleteButton() {
        deleteButton.isEnabled = canBeDeleted
        deleteButton.isHidden = !deleteButton.isEnabled
    }
    
}

extension TransactionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = textField.text ?? ""
        let nsText = text as NSString
        let modText = nsText.replacingCharacters(in: range, with: string)
        
        if textField.tag == 101 {
            return valueTextValidation(modText)
        }
        
        if textField.tag == 102 {
            return noteTextValidation(modText)
        }
        
        fatalError("TextField not recognized")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func valueTextValidation(_ modText: String) -> Bool {
        // Maximum 9 digits, 1 comma, 2 digits after comma
        let digits = modText.filter({ $0.isNumber })
        let postDigits = modText.drop(while: { $0 != "," })
        let commas = modText.filter({ $0 == "," })
        
        if digits.count + commas.count != modText.count {return false}
        if commas.count > 1 {return false}
        if postDigits.count > 3 {return false}
        if digits.count > 9 {return false}
        
        return true
    }
    
    private func noteTextValidation(_ modText: String) -> Bool {
        if modText.count > 25 { return false }
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
