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
    var eventNotifier: Subject = Subject()
    var nextAvailableTime: Date = Date()
    
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ModelManager.refetchData(.transaction, forFriend: forFriend)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowTransaction":
            guard let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("No cell selected")
            }
            
            guard let controller = segue.destination as? TransactionViewController else {
                fatalError("Destination is not a TransactionViewController")
            }
            
            let transaction = ModelManager.transaction(indexPath)
            controller.transactionData = transaction.toTransactionData()
            controller.friendData = transaction.who.toFriendData()
            controller.canBeDeleted = true
            controller.delegate = self
            
        default:
            fatalError("Invalid Segue Identifier")
        }
    }
    
    // MARK: Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ModelManager.transactionSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModelManager.transactionCount(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as? TransactionCell else {
            fatalError("dequeued cell is not a TransactionCell")
        }
        
        let transaction =  ModelManager.transaction(indexPath)
        cell.transaction = transaction.toTransactionData()
        cell.friend = transaction.who.toFriendData()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionDate = ModelManager.transaction(IndexPath(row: 0, section: section)).date
        if sectionDate.toString(format: "yyyy") == Date().toString(format: "yyyy") {
            return sectionDate.toString(format: "MMMM dd")
        } else {
            return sectionDate.toString(format: "MMMM dd yyyy")
        }
        
    }
    
    // MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(
            style: .destructive,
            title: "Delete"
        ) { (action, indexPath) in
            self.deleteTransaction(indexPath: indexPath)
        }
        
        let settleAction = UITableViewRowAction(
            style: .normal,
            title: "Settle up"
        ) { (action, indexPath) in
            self.settleTransaction(indexPath: indexPath)
        }
        
        settleAction.backgroundColor = ColorManager.settledColor
        
        return [deleteAction, settleAction]
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Initial setup
        let currentDate = Date()
        nextAvailableTime = max(nextAvailableTime, currentDate)
        
        let duration = 0.25
        let difference = duration / 4
        let delay = DateInterval(start: currentDate, end: nextAvailableTime).duration
        nextAvailableTime = currentDate.addingTimeInterval(delay).addingTimeInterval(difference)
        
        cell.alpha = 0.0
        cell.center.y -= 15
        
        // Animation
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.curveEaseOut],
            animations: {
                cell.alpha = 1.0
                cell.center.y += 15
        }, completion: nil)
    }
    
    
    
    // MARK: Private methods
    private func deleteTransaction(indexPath: IndexPath) {
        let transaction = ModelManager.transaction(indexPath)
        let emptySection = (ModelManager.transactionCount(in: indexPath.section) == 1)
        
        // Update the model
        ModelManager.deleteTransaction(transaction)
        ModelManager.saveContext()
        ModelManager.refetchData(.transaction, forFriend: forFriend)
        
        // Update the view
        if emptySection {
            tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        } else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        eventNotifier.notify()
    }
    
    private func settleTransaction(indexPath: IndexPath) {
        let transaction = ModelManager.transaction(indexPath)
        let reversed = transaction.reversedTransaction()
        ModelManager.saveContext()
        ModelManager.refetchData(.transaction, forFriend: forFriend)
        
        guard let indexPath = ModelManager.indexPath(forTransaction: reversed) else {
            fatalError("Reversed transaction not in fetched results")
        }
        
        if ModelManager.transactionCount(in: indexPath.section) == 1 {
            tableView.insertSections([indexPath.section], with: .automatic)
        } else {
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        
        eventNotifier.notify()
    }
    
}

extension TransactionListViewController: TransactionViewControllerDelegate {
    func transactionView(didEndEditing data: TransactionData?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("No cell selected")
        }
        
        let transaction = ModelManager.transaction(indexPath)
        
        guard let data = data else {
            deleteTransaction(indexPath: indexPath)
            return
        }
        
        transaction.currency = data.currency.rawValue
        transaction.date = data.date
        transaction.note = data.note
        transaction.value = data.value * (data.kind == .to ? 1.0 : -1.0)
        
        ModelManager.saveContext()
        eventNotifier.notify()
    }
    
    
}
