//
//  SummaryCell.swift
//  Owey
//
//  Created by Alex Tatomir on 17/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import UIKit

class SummaryCell: UICollectionViewCell {
   
    // MARK: Outlets
    @IBOutlet weak var owingLabel: UILabel!
    @IBOutlet weak var owedLabel: UILabel!
    @IBOutlet weak var settledLabel: UILabel!
    
    // MARK: Properties
    
    
    // MARK: Initialization
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
