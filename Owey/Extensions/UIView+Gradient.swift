//
//  UIView+Gradient.swift
//  Owey
//
//  Created by Alex Tatomir on 04/09/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addGradientLayer(cornerRadius: CGFloat = 0.00) {
        let view = UIView()
        
        self.superview?.addSubview(view)
        self.superview?.sendSubviewToBack(view)
        view.frame = self.frame
        
        view.setGradient()
        view.setCornerRadius(radius: cornerRadius)
    }
    
    func setGradient() {
        let gradient = CAGradientLayer()
        
        gradient.colors = [ColorManager.gradientUpColor, ColorManager.gradientDownColor].map({$0.cgColor})
        gradient.frame = self.bounds
        
        if let already = layer.sublayers, already.count >= 1 {
            layer.replaceSublayer(already[0], with: gradient)
        } else {
            self.layer.addSublayer(gradient)
        }
    }
    
}


