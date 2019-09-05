//
//  UIView+Shadow.swift
//  Owey
//
//  Created by Alex Tatomir on 05/09/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addShadow(radius: CGFloat){
        layer.masksToBounds = false
        clipsToBounds = false
        
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = UIColor.blue.cgColor
        
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 2
        
        if let layers = layer.sublayers {
            for old in layers {
                if old.shadowOpacity > 0.1 {
                    layer.replaceSublayer(old, with: shadowLayer)
                    return
                }
            }
        }
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
}
