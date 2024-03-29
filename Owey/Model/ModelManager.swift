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
    private static let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
    private static let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    private static var friendFetcher: NSFetchedResultsController<Friend>!
    
    private static var transactionFetcher: NSFetchedResultsController<Transaction>!
    private static var transactionForFriend: Friend?
    
    
    
    class func saveContext() {
        appDelegate?.saveContext()
    }
    
    class func refetchData(_ type: FetchType, forFriend: Friend? = nil) {
        
        transactionForFriend = forFriend
        
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
            
            if let requiredFriend = transactionForFriend {
                let predicate = NSPredicate(format: "who = %@", requiredFriend)
                request.predicate = predicate
            } else {
                request.predicate = nil
            }
            
            transactionFetcher = NSFetchedResultsController<Transaction>(
                fetchRequest: request,
                managedObjectContext: persistentContainer.viewContext,
                sectionNameKeyPath: #keyPath(Transaction.headerStringDate),
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
    
    class func fetchedFriends() -> [Friend] {
        return friendFetcher.fetchedObjects!
    }
}

// Extension for transaction
extension ModelManager {
    class func newTransaction() -> Transaction {
        return Transaction(entity: Transaction.entity(), insertInto: persistentContainer.viewContext)
    }
    
    class func transaction(_ indexPath: IndexPath) -> Transaction {
        return transactionFetcher.object(at: indexPath)
    }
    
    class func transactionSections() -> Int {
        guard let sections = transactionFetcher.sections else {
            fatalError("Sections coulnd not be retrieved")
        }
        return sections.count
    }
    
    class func transactionCount(in section: Int) -> Int {
        guard let sections = transactionFetcher.sections else {
            fatalError("Sections coulnd not be retrieved")
        }
        return sections[section].numberOfObjects
    }
    
    class func deleteTransaction(_ transaction: Transaction) {
        persistentContainer.viewContext.delete(transaction)
    }
    
    class func fetchedTransactions() -> [Transaction] {
        return transactionFetcher.fetchedObjects!
    }
    
    class func indexPath(forTransaction transaction: Transaction) -> IndexPath? {
        return transactionFetcher.indexPath(forObject: transaction)
    }
}
