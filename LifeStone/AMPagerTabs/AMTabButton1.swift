//
//  AMTabButton1.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 18/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import Foundation

import UIKit

class AMTabButton1: UIButton {
    
    var index: Int?
    
    override func draw(_ rect: CGRect) {
        addTabSeparatorLine()
    }
    
    private func addTabSeparatorLine(){
        let gradientMaskLayer: CAGradientLayer = CAGradientLayer()
        gradientMaskLayer.frame = self.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        gradientMaskLayer.locations = [0.0, 0.5]
        gradientMaskLayer.frame = CGRect(x: 0, y: 0, width: 0.5, height: self.frame.height)
        layer.addSublayer(gradientMaskLayer)
    }
    
}
