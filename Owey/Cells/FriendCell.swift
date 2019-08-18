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
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var owingLabel: UILabel!
    @IBOutlet weak var owedLabel: UILabel!
    @IBOutlet weak var settledLabel: UILabel!
    
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
    
    // MARK: Private methods
    func resetSummary() {
        _ = self.contentView
        
        owingLabel.textColor = ColorManager.redTextOnBlue
        owedLabel.textColor = ColorManager.greenTextOnBlue
        settledLabel.textColor = ColorManager.settledColor
        
        // TODO: Hide or show labels
    }
}
