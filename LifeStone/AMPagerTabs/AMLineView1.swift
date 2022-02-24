//
//  AMLineView1.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 21/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import Foundation
import UIKit

class AMLineView1: UIView {
    
    var lineHeight: CGFloat = 7
    var lineColor = UIColor.white
    
    
    
    override func draw(_ rect: CGRect) {
        drawSelectedTabLine()
    }
    
    private func drawSelectedTabLine(){
        let height = frame.height
        let width = frame.width
        let triangleSize:CGFloat = 5
        
        let path = UIBezierPath()
        // draw the lines of the shape
        path.move(to: CGPoint(x: 0, y: height-lineHeight))
//        path.addLine(to: CGPoint(x: (width/2)-triangleSize, y: height-lineHeight))
//        path.addLine(to: CGPoint(x: (width/2), y: height-lineHeight-triangleSize))
        path.addLine(to: CGPoint(x: (width/2)+triangleSize , y: height-lineHeight))
        path.addLine(to: CGPoint(x: width , y: height-lineHeight))
        path.addLine(to: CGPoint(x: width , y: height))
        path.addLine(to: CGPoint(x: 0 , y: height))
        path.addLine(to: CGPoint(x: 0 , y: height-lineHeight))
        path.close()
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        clipsToBounds = true
    }
    
    
}
