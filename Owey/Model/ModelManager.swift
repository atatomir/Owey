//
//  ModelManager.swift
//  Owey
//
//  Created by Alex Tatomir on 18/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ModelManager {
    enum FetchType {
        case friend
        case transaction
        case all
    }
    
    // MARK: Properties
    static let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
    static let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    static var friendFetcher: NSFetchedResultsController<Friend>!
    
    static var transactionFetcher: NSFetchedResultsController<Transaction>!
    static var transitionsForFriend: Friend?
    
    
    
    class func saveContext() {
        appDelegate?.saveContext()
    }
    
    class func refetchData(for type: FetchType) {
        
        if type == .friend || type == .all {
            let request = Friend.fetchRequest() as NSFetchRequest<Friend>
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            friendFetcher = NSFetchedResultsController<Friend>(
                fetchRequest: request,
                managedObjectContext: persistentContainer.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            do {
                try friendFetcher.performFetch()
                print("Fetched \(friendFetcher.fetchedObjects?.count ?? 0) friends")
            } catch {
                fatalError("Could not fetch friends")
            }
        }
        
        if type == .transaction || type == .all {
            let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            
            if let requiredFriend = transitionsForFriend {
                let predicate = NSPredicate(format: "who = %@", requiredFriend)
                request.predicate = predicate
            } else {
                request.predicate = nil
            }
            
            transactionFetcher = NSFetchedResultsController<Transaction>(
                fetchRequest: request,
                managedObjectContext: persistentContainer.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            do {
                try transactionFetcher.performFetch()
                print("Fetched \(transactionFetcher.fetchedObjects?.count ?? 0) transactions")
            } catch {
                fatalError("Could not fetch friends")
            }
        }
        
        // Add other types...
    }
}

// Extension for friend
extension ModelManager {
    class func newFriend() -> Friend {
        return Friend(entity: Friend.entity(), insertInto: persistentContainer.viewContext)
    }
    
    class func friend(_ index: Int) -> Friend {
        return friendFetcher.object(at: IndexPath(row: index, section: 0))
    }
    
    class func friendCount() -> Int {
        return friendFetcher.fetchedObjects?.count ?? 0
    }
    
    class func deleteFriend(_ friend: Friend) {
        persistentContainer.viewContext.delete(friend)
    }
}

// Extension for transaction
extension ModelManager {
    class func newTransaction() -> Transaction {
        return Transaction(entity: Transaction.entity(), insertInto: persistentContainer.viewContext)
    }
    
    class func transaction(_ index: Int) -> Transaction {
        return transactionFetcher.object(at: IndexPath(row: index, section: 0))
    }
    
    class func transactionCount() -> Int {
        return transactionFetcher.fetchedObjects?.count ?? 0
    }
    
    class func deleteTransaction(_ transaction: Transaction) {
        persistentContainer.viewContext.delete(transaction)
    }
}
