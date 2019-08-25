//
//  UIRoundedView.swift
//  Owey
//
//  Created by Alex Tatomir on 18/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import UIKit

@IBDesignable class RoundedImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            updateRoundedCorners()
        }
    }
    
    @IBInspectable var circleMask: Bool = false {
        didSet {
            updateRoundedCorners()
        }
    }
    
    func updateRoundedCorners() {
        if circleMask {
            let radius = min(self.frame.height, self.frame.width) / 2
            setCornerRadius(radius: radius)
        } else {
            setCornerRadius(radius: cornerRadius)
        }
    }
    
}
