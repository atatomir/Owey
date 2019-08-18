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
    
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        ModelManager.refetchData(for: .all)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowFriendDetails":
            if let detailsVC = segue.destination as? FriendDetailsViewController {
                detailsVC.delegate = self
                
                let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)!
                let friend = ModelManager.friend(indexPath.row - 1)
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
    
}

// MARK: Collection View Data Source
extension FriendsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ModelManager.friendCount() + 1
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
            
            let fetchedFriend = ModelManager.friend(indexPath.row - 1)
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
            
            let friend = ModelManager.friend(selected[0].row - 1)
            
            guard let data = friendData else {
                // Delete an item
                ModelManager.deleteFriend(friend)
                ModelManager.saveContext()
                
                ModelManager.refetchData(for: .friend)
                collectionView.reloadData()
                
                return
            }
            
            // Change selected item
            friend.name = data.name
            friend.picture = data.image
            
        } else {
            guard let data = friendData else {return}
            
            // Add a new friend
            let newFriend = ModelManager.newFriend()
            newFriend.name = data.name
            newFriend.picture = data.image
        }
        
        ModelManager.saveContext()
        ModelManager.refetchData(for: .all)

        collectionView.reloadData()
    }
    
}
