//
//  TransactionListViewController.swift
//  Owey
//
//  Created by Alex Tatomir on 19/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import UIKit

class TransactionListViewController: UITableViewController {
    
    // MARK: Properties
    var totalHeight: CGFloat {
        return tableView.frame.height
    }
    
    var forFriend: Friend?

    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        ModelManager.transactionForFriend = forFriend
        ModelManager.refetchData(for: .transaction)
        tableView.reloadData()
    }
    
    // MARK: Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModelManager.transactionCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as? TransactionCell else {
            fatalError("dequeued cell is not a TransactionCell")
        }
        
        let transaction =  ModelManager.transaction(indexPath.row)
        cell.transaction = transaction.toTransactionData()
        cell.friend = transaction.who.toFriendData()
        
        return cell
    }
    
    // MARK: Table View Delegate

    
    
}
