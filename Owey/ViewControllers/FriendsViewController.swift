//
//  FriendsViewController.swift
//  Owey
//
//  Created by Alex Tatomir on 17/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import UIKit
import CoreData

class FriendsViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: Properties
    var totalWidth: CGFloat {
        return collectionView.frame.width
    }
    
    var totalHeight: CGFloat {
        return collectionView.frame.height
    }
    
    let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
    let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var friendFetcher: NSFetchedResultsController<Friend>!
    
    
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        refetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowFriendDetails":
            if let detailsVC = segue.destination as? FriendDetailsViewController {
                detailsVC.delegate = self
                
                let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)!
                let index = IndexPath(row: indexPath.row - 1, section: 0)
                let friend = friendFetcher.object(at: index)
                detailsVC.friend = FriendData(name: friend.name, image: friend.picture as! UIImage)
                
            } else {
                fatalError("Segue destination is not FriendDetailsViewController")
            }
            
        case "NewFriend":
            if let detailsVC = segue.destination as? FriendDetailsViewController {
                detailsVC.delegate = self
            } else {
                fatalError("Segue destination is not FriendDetailsViewController")
            }
            
        default:
            break
        }
    }
    
    // MARK: Actions
    @IBAction func newFriend(_ sender: UIBarButtonItem) {
        deselectAllItems()
    }
    
    
    // MARK: Private Methods
    func deselectAllItems() {
        if let selected = collectionView.indexPathsForSelectedItems {
            for item in selected {
                collectionView.deselectItem(at: item, animated: true)
            }
        }
    }
    
    func refetchData() {
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
            print("Fetched \(friendFetcher.fetchedObjects?.count) friends")
        } catch {
            fatalError("Could not fetch friends")
        }
    }
}

// MARK: Collection View Data Source
extension FriendsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (friendFetcher.fetchedObjects?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SummaryCell", for: indexPath) as? SummaryCell else {
                fatalError("First cell in FriendsCollectionView is not a SummaryCell")
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
                fatalError("Cell in FriendsCollectionView is not a FriendCell")
            }
            
            let index = IndexPath(row: indexPath.row - 1, section: 0)
            
            let fetchedFriend = friendFetcher.object(at: index)
            cell.friend = FriendData(name: fetchedFriend.name, image: fetchedFriend.picture as! UIImage)
            
            return cell
        }
    }
    
}

// MARK: Collection View Delegate
extension FriendsViewController: UICollectionViewDelegate {
    
}

// MARK: Collection View Flow Layout
extension FriendsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            let width = totalWidth - 20
            let height = width * 80 / 350
            
            return CGSize(width: width, height: height)
        } else {
            let width = (totalWidth - 30) / 2
            let height = width * 200 / 170
            
            return CGSize(width: width, height: height)
        }
    }
}

extension FriendsViewController: FriendDetailsViewControllerDelegate {
    
    func friendDetails(didReturnWith friendData: FriendData?) {
        
        
        if let selected = collectionView.indexPathsForSelectedItems, selected.count > 0 {
            
            let index = IndexPath(row: selected[0].row - 1, section: 0)
            let friend = friendFetcher.object(at: index)
            
            guard let data = friendData else {
                // Delete an item
                persistentContainer.viewContext.delete(friend)
                appDelegate?.saveContext()
                
                refetchData()
                collectionView.reloadData()
                
                return
            }
            
            // Change selected item
            friend.name = data.name
            friend.picture = data.image
            
        } else {
            guard let data = friendData else {return}
            
            // Add a new friend
            let newFriend = Friend(entity: Friend.entity(), insertInto: persistentContainer.viewContext)
            newFriend.name = data.name
            newFriend.picture = data.image
        }
        
        appDelegate?.saveContext()
        
        refetchData()
        collectionView.reloadData()
    }
    
}
