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
        
        customizeNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ModelManager.refetchData(.all)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowFriendDetails":
            // The cell must be selected prior to preparing for segure
            if let detailsVC = segue.destination as? FriendDetailsViewController {
                detailsVC.delegate = self
                
                let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)!
                let friend = ModelManager.friend(indexPath.row - 1)
                detailsVC.friendData = friend.toFriendData()
                detailsVC.refFriend = friend
                detailsVC.canBeDeleted = true
                
            } else {
                fatalError("Segue destination is not FriendDetailsViewController")
            }
            
        case "NewFriend":
            if let detailsVC = segue.destination as? FriendDetailsViewController {
                detailsVC.delegate = self
                detailsVC.canBeDeleted = false
            } else {
                fatalError("Segue destination is not FriendDetailsViewController")
            }
        
        case "NewTransaction":
            /* The cell must be selected prior to preparing for segue.
             * Buttons have tags to be distinguishable. */
            if let transactionVC = segue.destination as? TransactionViewController {
                let selected = collectionView.indexPathsForSelectedItems![0]
                let friend = ModelManager.friend(selected.row - 1)
                
                transactionVC.delegate = self
                transactionVC.transactionData = TransactionData(
                    currency: Currency.USD,
                    value: -1.00,
                    note: "",
                    date: Date(),
                    kind: (sender as! UIButton).tag == 11 ? .to : .from
                )
                transactionVC.friendData = friend.toFriendData()
                transactionVC.canBeDeleted = false
                
            } else {
                fatalError("Segue destination is not TransactionViewController")
            }
            
        default:
            break
        }
    }
    
    // MARK: Actions
    @IBAction func newFriend(_ sender: UIBarButtonItem) {
        deselectAllItems()
        performSegue(withIdentifier: "NewFriend", sender: self)
    }
    
    @IBAction func handleGiveMoney(_ sender: UIButton) {
        var cell: UIView = sender
        
        while !(cell is FriendCell) {
            cell = cell.superview!
        }
        let indexPath = collectionView.indexPath(for: cell as! UICollectionViewCell)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        
        performSegue(withIdentifier: "NewTransaction", sender: sender)
    }
    
    @IBAction func handleTakeMoney(_ sender: UIButton) {
        handleGiveMoney(sender)
    }
    
    // MARK: Private Methods
    private func deselectAllItems() {
        if let selected = collectionView.indexPathsForSelectedItems {
            for item in selected {
                collectionView.deselectItem(at: item, animated: true)
            }
        }
    }
    
    private func customizeNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func deleteFriend(_ friend: Friend) {
        let transactionCount = friend.transactions.count
        
        ModelManager.deleteFriend(friend)
        ModelManager.saveContext()
        ModelManager.refetchData(.friend)
        
        self.collectionView.reloadData()
        print("\(transactionCount) transaction deleted with friend \(friend.name)")
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
            cell.friend = fetchedFriend.toFriendData()
            cell.refFriend = fetchedFriend

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? FriendCell {
            cell.updateUI()
        }
        
        if let cell = cell as? SummaryCell {
            cell.updateUI()
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
            let height = width * 50 / 350
            
            return CGSize(width: width, height: height)
        } else {
            let width = (totalWidth - 30) / 2
            let height = width * 200 / 170
            
            return CGSize(width: width, height: height)
        }
    }
}

// MARK: Friend Details View Delegate
extension FriendsViewController: FriendDetailsViewControllerDelegate {
    
    func friendDetails(didEndEditing friendData: FriendData?) {
        
        if let selected = collectionView.indexPathsForSelectedItems, selected.count > 0 {
            let friend = ModelManager.friend(selected[0].row - 1)
            
            guard let data = friendData else {
                deleteFriend(friend)
                return
            }
            
            // Change selected item
            friend.name = data.name
            friend.picture = data.image
            
        } else {
            guard let data = friendData else {return}
            
            // Add a new friend
            _ = data.toFriend()
        }
        
        ModelManager.saveContext()
        ModelManager.refetchData(.all)

        collectionView.reloadData()
    }
    
}

// MARK: Transition View Delegate
extension FriendsViewController: TransactionViewControllerDelegate {
    
    func transactionView(didEndEditing transactionData: TransactionData?) {
        let selected = collectionView.indexPathsForSelectedItems![0]
        let friend = ModelManager.friend(selected.row - 1)
        
        guard let transactionData = transactionData else {
            fatalError("New transaction returned with delete command")
        }
        
        _ = transactionData.toTransaction(owner: friend)
        ModelManager.saveContext()
    }
    
    
}
