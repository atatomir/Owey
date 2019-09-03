//
//  FriendDetailsViewController.swift
//  Owey
//
//  Created by Alex Tatomir on 18/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import UIKit

protocol FriendDetailsViewControllerDelegate {
    // return nil if you want to delete this friend
    func friendDetails(didEndEditing: FriendData?)
}

/* Initialize this View Controller by providing a FriendData(and a Friend if you want history details).
 * Result is returned via the delegate's frunction friendDetailsDidEndEditing
 */
class FriendDetailsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var profilePicture: RoundedImageView!
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var owingLabel: UILabel!
    @IBOutlet var owedLabel: UILabel!
    @IBOutlet var settledLabel: UILabel!
    @IBOutlet var tableViewContainer: UIView!
    @IBOutlet var detailsStack: UIStackView!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var deleteButton: UIButton!
    
    // MARK: Properties
    var friendData: FriendData?
    var refFriend: Friend?
    var canBeDeleted: Bool = false
    
    var imagePicker = UIImagePickerController()
    var delegate: FriendDetailsViewControllerDelegate?
    
    var tableViewController: TransactionListViewController!
    var tableView: UITableView!
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        nameLabel.delegate = self
        
        // Initialize UI
        navigationItem.largeTitleDisplayMode = .never
        backgroundView.setCornerRadius()
        
        // Editing or Adding a friend?
        if let friend = friendData {
            profilePicture.image = friend.image
            nameLabel.text = friend.name
            navigationItem.title = friend.name
            setSummary(hidden: false)
        } else {
            profilePicture.image = UIImage(named: "Ricky")
            nameLabel.text = ""
            navigationItem.title = "New friend"
            nameLabel.becomeFirstResponder()
            setSummary(hidden: true)
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
            
            tableViewController.eventNotifier.addObserver(observer: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadSummary()
        updateDoneButton()
        updateDeleteButton()
    }
    
    
    
    //MARK: Actions
    
    @IBAction func done(_ sender: Any) {
        friendData = FriendData(name: nameLabel.text!, image: profilePicture.image!)
        delegate?.friendDetails(didEndEditing: friendData)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteFriend(_ sender: Any) {
        
        if let friend = refFriend {
            let transactionCount = friend.transactions.count
            var transactionMessage: String = friend.name
            transactionMessage += (friend.name.last == "s" ? "'" : "'s")
            transactionMessage += " transaction" + (transactionCount > 1 ? "s" : "")
            transactionMessage += " will be deleted"
            if transactionCount > 1 { transactionMessage += "(\(transactionCount))"}
            if transactionCount == 0 {
                transactionMessage = ""
            }
            
            let alert = UIAlertController(
                title: "Delete \(friend.name)?",
                message: transactionMessage,
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
            
            let deleteAction = UIAlertAction(
                title: "Delete",
                style: .destructive,
                handler: { _ in
                    self.delegate?.friendDetails(didEndEditing: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            )
    
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        } else {
            fatalError("Trying to delete a null refFriend")
        }
        
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
    
    private func updateDoneButton() {
        if let text = nameLabel.text, text.count > 0 {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    private func updateDeleteButton() {
        deleteButton.isEnabled = canBeDeleted
        deleteButton.isHidden = !canBeDeleted
    }
    
    private func setSummary(hidden: Bool = false) {
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
    
    private func reloadSummary() {
        if let _ = friendData {
            setSummary(hidden: false)
        } else {
            setSummary(hidden: true)
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

extension FriendDetailsViewController: Observer {
    func update(by subject: Subject) {
        // Update from history view
        reloadSummary()
    }
    
}
