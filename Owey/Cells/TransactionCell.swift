//
//  TransactionCellTableViewCell.swift
//  Owey
//
//  Created by Alex Tatomir on 19/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var textStack: UIStackView!
    @IBOutlet weak var picture: RoundedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: Properties
    var friend: FriendData? { didSet { initializeData() } }
    var transaction: TransactionData? { didSet { initializeData() } }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        picture.updateRoundedCorners()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Private Methods
    private func initializeData() {
        if let friend = friend, let transaction = transaction {
            picture.image = friend.image
            titleLabel.text = transaction.note
            infoLabel.text = transaction.currency.rawValue + String(transaction.value) + " " + transaction.kind.rawValue.lowercased() + " " + friend.name
            dateLabel.text = transaction.date.toString(format: "HH:mm")
            
            if transaction.kind == .from {
                infoLabel.textColor = ColorManager.greenTextOnGrey
                titleLabel.textAlignment = .left
                infoLabel.textAlignment = .left
                dateLabel.textAlignment = .left
                
                let stack = textStack.superview as! UIStackView
                stack.removeArrangedSubview(textStack)
                stack.addArrangedSubview(textStack)
                
            } else {
                infoLabel.textColor = ColorManager.redTextOnGrey
                titleLabel.textAlignment = .right
                infoLabel.textAlignment = .right
                dateLabel.textAlignment = .right
                
                let stack = picture.superview as! UIStackView
                stack.removeArrangedSubview(picture)
                stack.addArrangedSubview(picture)
            }
        }
    }

}
