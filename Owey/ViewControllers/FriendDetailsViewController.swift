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

/* Initialize this View Controller by providing a FriendData.
 * Result is returned via the delegate's frunction friendDetailsDidEndEditing
 */
class FriendDetailsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var owingLabel: UILabel!
    @IBOutlet var owedLabel: UILabel!
    @IBOutlet var settledLabel: UILabel!
    
    // MARK: Properties
    var friend: FriendData?
    var imagePicker = UIImagePickerController()
    var delegate: FriendDetailsViewControllerDelegate?
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        nameLabel.delegate = self
        
        if let friend = friend {
            profilePicture.image = friend.image
            nameLabel.text = friend.name
            navigationItem.title = friend.name
            resetSummary()
        } else {
            profilePicture.image = UIImage(named: "Ricky")
            nameLabel.text = "Name"
            navigationItem.title = "Name"
            hideLabels()
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
    
    // MARK: Private methods
    private func resetSummary() {
        owingLabel.textColor = ColorManager.redTextOnBlue
        owedLabel.textColor = ColorManager.greenTextOnBlue
        settledLabel.textColor = ColorManager.settledColor
        
        // TODO: Hide or show labels
    }

    private func hideLabels() {
        owingLabel.isHidden = true
        owedLabel.isHidden = true
        settledLabel.isHidden = true
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

