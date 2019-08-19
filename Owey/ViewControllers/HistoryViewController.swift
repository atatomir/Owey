//
//  HistoryViewController.swift
//  Owey
//
//  Created by Alex Tatomir on 19/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var tableViewController: TransactionListViewController!
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Transaction", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TransactionList") as! TransactionListViewController
        
        tableViewController = controller
        tableView = controller.view as? UITableView
        
        self.addChild(controller)
        controller.didMove(toParent: self)
        
        self.view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
}
