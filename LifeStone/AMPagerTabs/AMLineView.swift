//
//  AMLineView.swift
//  AMPagerTabs
//
//  Created by abedalkareem omreyh on 10/26/17.
//  Copyright © 2017 abedalkareem omreyh. All rights reserved.
//  GitHub: https://github.com/Abedalkareem/AMPagerTabs
//

import UIKit

class AMLineView: UIView {
    
    var lineHeight: CGFloat = 7
    var lineColor = UIColor.white
    
    
    override func draw(_ rect: CGRect) {
            drawSelectedTabLineTop()
        
        
    }
    
    private func drawSelectedTabLineBottom(){
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
    
    private func drawSelectedTabLineTop(){

        let width = frame.width
        let triangleSize:CGFloat = 5
        let path = UIBezierPath()
        // draw the lines of the shape
        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: (width/2)-triangleSize, y: height-lineHeight))
//        path.addLine(to: CGPoint(x: (width/2), y: height-lineHeight-triangleSize))
        path.addLine(to: CGPoint(x: (width/2)+triangleSize , y: 0))
        path.addLine(to: CGPoint(x: width , y: 0))
        path.addLine(to: CGPoint(x: width , y: lineHeight))
        path.addLine(to: CGPoint(x: 0 , y: lineHeight))
        path.addLine(to: CGPoint(x: 0 , y: lineHeight))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        clipsToBounds = true
    }

    
}
