//
//  Gradient.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 30/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//


import Foundation
import UIKit


//
//class GradientView: UIView {
//
//    // Default Colors
//    var colors:[UIColor] = [#colorLiteral(red: 0.4116025269, green: 0.7255352139, blue: 0.8626369238, alpha: 1),#colorLiteral(red: 0.2702776194, green: 0.7569042444, blue: 0.6861851811, alpha: 1),#colorLiteral(red: 0.4116025269, green: 0.7255352139, blue: 0.8626369238, alpha: 1)]
//
//    override func draw(_ rect: CGRect) {
//
//        // Must be set when the rect is drawn
//        setGradient(color1: colors[0], color2: colors[1],color3: colors[2])
//    }
//
//
//    func setGradient(color1: UIColor, color2: UIColor, color3: UIColor) {
//
//        let context = UIGraphicsGetCurrentContext()
//        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [color1.cgColor, color2.cgColor] as CFArray, locations: [0, 1])!
//
//        // Draw Path
//        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
//        context!.saveGState()
//        path.addClip()
//        context!.drawLinearGradient(gradient, start: CGPoint(x: frame.width / 2, y: 0), end: CGPoint(x: frame.width / 2, y: frame.height), options: CGGradientDrawingOptions())
//        context!.restoreGState()
//    }
//
//    override func layoutSubviews() {
//
//        // Ensure view has a transparent background color (not required)
//        backgroundColor = UIColor.clear
//    }
//
//}

public extension UIView {

    private static let kLayerNameGradientBorder = "GradientBorderLayer"
    
    func setGradientBorder(
        Rect:CGRect,
        cornerRadius: CGFloat,
        width: CGFloat,
        colors: [UIColor],
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1)
        ) {
        let existedBorder = gradientBorderLayer()
        let border = existedBorder ?? CAGradientLayer()
        border.frame = bounds
        border.colors = colors.map { return $0.cgColor }
        border.startPoint = startPoint
        border.endPoint = endPoint
        
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect:Rect, cornerRadius: cornerRadius).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = width
        
        border.mask = mask
        
        let exists = existedBorder != nil
        if !exists {
            layer.addSublayer(border)
        }
    }
    
    func removeGradientBorder() {
        self.gradientBorderLayer()?.removeFromSuperlayer()
    }
    
    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameGradientBorder }
        if borderLayers?.count ?? 0 > 1 {
            fatalError()
        }
        return borderLayers?.first as? CAGradientLayer
    }
}
