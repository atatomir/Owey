//
//  FriendCell.swift
//  Owey
//
//  Created by Alex Tatomir on 18/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import Foundation
import UIKit

class FriendCell: UICollectionViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var owingLabel: UILabel!
    @IBOutlet weak var owedLabel: UILabel!
    @IBOutlet weak var settledLabel: UILabel!
    
    // MARK: Properties
    var refFriend: Friend!
    
    var friend: FriendData! {
        didSet {
            guard let friend = friend else {
                fatalError("Friend value not set")
            }
            
            picture.image = friend.image
            nameLabel.text = friend.name
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.setCornerRadius()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.setCornerRadius()
    }
    
    func setSummary() {
        _ = self.contentView
        
        owingLabel.textColor = ColorManager.redTextOnBlue
        owedLabel.textColor = ColorManager.greenTextOnBlue
        settledLabel.textColor = ColorManager.settledColor
        
        let owingTexts = OwingList(for: refFriend).allTexts()
        owingLabel.text = owingTexts.0
        owedLabel.text = owingTexts.1
        settledLabel.text = owingTexts.2
        
        for item in [owingLabel!, owedLabel!, settledLabel!] {
            item.isHidden = (item.text == nil)
        }
    }
    
    // MARK: Private methods
}
