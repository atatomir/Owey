//
//  ResetViewController.swift
//  Owey
//
//  Created by Alex Tatomir on 19/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleReset(_ sender: UIButton) {
        
        for friend in ModelManager.fetchedFriends() {
            ModelManager.deleteFriend(friend)
        }
        
        for transaction in ModelManager.fetchedTransactions() {
            ModelManager.deleteTransaction(transaction)
        }
        
        ModelManager.saveContext()
    }


}
