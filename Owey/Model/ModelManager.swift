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
        case all
    }
    
    static let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
    static let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    static var friendFetcher: NSFetchedResultsController<Friend>!
    
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
        
        // Add other types...
    }
}

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
