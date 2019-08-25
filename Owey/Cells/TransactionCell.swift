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
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MM yyyy HH:mm"
        return formatter
    }()
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            infoLabel.text = transaction.currency.rawValue + " " + String(transaction.value) + " " + transaction.kind.rawValue.lowercased() + " " + friend.name
            dateLabel.text = formatter.string(from: transaction.date)
            
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
        
        picture.updateRoundedCorners()
    }

}
