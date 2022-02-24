//
//  Models.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 08/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import Foundation
import UIKit

class CustomPageControl: UIPageControl {
    
    var borderColor: UIColor = .white
    
    override var currentPage: Int {
        didSet {
            updateBorderColor()
        }
    }
    
    func updateBorderColor() {
        subviews.enumerated().forEach { index, subview in
            if index != currentPage {
                subview.layer.borderColor = borderColor.cgColor
                subview.layer.borderWidth = 1
            } else {
                subview.layer.borderWidth = 0
            }
        }
    }
    
}
