//
//  FriendDetailsViewController.swift
//  Owey
//
//  Created by Alex Tatomir on 18/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import UIKit

protocol FriendDetailsViewControllerDelegate {
    func friendDetails(didEndEditing: FriendData?)
}

/* Initialize this View Controller by providing a FriendData(and a Friend if you want history details).
 * Result is returned via the delegate's frunction friendDetailsDidEndEditing
 */
class FriendDetailsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var owingLabel: UILabel!
    @IBOutlet var owedLabel: UILabel!
    @IBOutlet var settledLabel: UILabel!
    @IBOutlet var tableViewContainer: UIView!
    @IBOutlet var detailsStack: UIStackView!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    // MARK: Properties
    var friend: FriendData?
    var refFriend: Friend?
    
    var imagePicker = UIImagePickerController()
    var delegate: FriendDetailsViewControllerDelegate?
    
    var tableViewController: UITableViewController!
    var tableView: UITableView!
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Title
        navigationItem.largeTitleDisplayMode = .never
        
        // Delegates
        nameLabel.delegate = self
        
        // Editing or Adding a friend?
        if let friend = friend {
            profilePicture.image = friend.image
            nameLabel.text = friend.name
            navigationItem.title = friend.name
            setSummary()
        } else {
            profilePicture.image = UIImage(named: "Ricky")
            nameLabel.text = "Name"
            navigationItem.title = "Name"
            setSummary(hidden: true)
            nameLabel.becomeFirstResponder()
        }
        
        // Initialize history
        if let refFriend = refFriend {
            let storyboard = UIStoryboard(name: "Transaction", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TransactionList") as! TransactionListViewController
            
            tableViewController = controller
            tableView = controller.view as? UITableView
            
            self.addChild(controller)
            controller.didMove(toParent: self)
            controller.forFriend = refFriend
            
            self.tableViewContainer.addSubview(tableView)
            tableView.frame = CGRect(x: 0, y: 0, width: tableViewContainer.frame.width, height: tableViewContainer.frame.height)
        }
    }
    
    func setSummary(hidden: Bool = false) {
        if hidden {
            owedLabel.isHidden = true
            owingLabel.isHidden = true
            settledLabel.isHidden = true
        }
        guard let refFriend = refFriend else {return}
        
        owingLabel.textColor = ColorManager.redTextOnBlue
        owedLabel.textColor = ColorManager.greenTextOnBlue
        settledLabel.textColor = ColorManager.settledColor
        
        let owingTexts = OwingList(for: refFriend).allTexts()
        owingLabel.text = owingTexts.0
        owedLabel.text = owingTexts.1
        settledLabel.text = owingTexts.2
        
        for item in [owingLabel!, owedLabel!, settledLabel!] {
            item.isHidden = (item.text == nil)
        }
    }
    
    
    
    //MARK: Actions
    
    @IBAction func done(_ sender: Any) {
        friend = FriendData(name: nameLabel.text!, image: profilePicture.image!)
        delegate?.friendDetails(didEndEditing: friend)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removeFriend(_ sender: Any) {
        delegate?.friendDetails(didEndEditing: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeImage(_ sender: UITapGestureRecognizer) {
        nameLabel.resignFirstResponder()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        updateDoneButton()
    }
    
    // MARK: Private methods
    
    private func hideLabels() {
        owingLabel.isHidden = true
        owedLabel.isHidden = true
        settledLabel.isHidden = true
    }
    
    @objc private func updateDoneButton() {
        if let text = nameLabel.text, text.count > 0 {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
}

extension FriendDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        navigationItem.title = textField.text
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = textField.text
        textField.resignFirstResponder()
    }
    
    
}

extension FriendDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        profilePicture.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
}

