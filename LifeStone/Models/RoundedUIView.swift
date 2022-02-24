//
//  RoundedUIView.swift
//  Twilio Recording
//
//  Created by Irfan Shah on 04/07/2019.
//  Copyright © 2019 Brent Schooley. All rights reserved.
//


import UIKit
import CoreGraphics
import CoreFoundation
import AVKit
import AVFoundation


class mylbl: UILabel{
    
    var isTitleVisible:Bool?
    
}

class VideoView: UIView {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(url: String) {
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bounds
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            if let playerLayer = self.playerLayer {
                layer.addSublayer(playerLayer)
            }
            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        }
    }
    
    func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        }
    }
}

@IBDesignable
class DottedView : UIView{
    @IBInspectable var perDashLength: CGFloat = 2.0
    @IBInspectable var spaceBetweenDash: CGFloat = 2.0
    @IBInspectable var dashColor: UIColor = UIColor.darkGray
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let  path = UIBezierPath()
        if height > width {
            let  p0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
            path.move(to: p0)
            
            let  p1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
            path.addLine(to: p1)
            path.lineWidth = width
            
        } else {
            let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
            path.move(to: p0)
            
            let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
            path.addLine(to: p1)
            path.lineWidth = height
        }
        
        let  dashes: [ CGFloat ] = [ perDashLength, spaceBetweenDash ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        
        path.lineCapStyle = .butt
        dashColor.set()
        path.stroke()
    }
    
    private var width : CGFloat {
        return self.bounds.width
    }
    
    private var height : CGFloat {
        return self.bounds.height
    }
    
}


@IBDesignable
class RoundUIView: UIView {
    
   
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var Dropshadow: Bool = false {
        didSet {
            self.dropShadow2(color: .darkGray, opacity: 0.3, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        }
    }
 
    @IBInspectable var TwoCorners: CGFloat = 0.0 {
        didSet {
            let corners: UIRectCorner = [.topLeft, .bottomRight]
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 10, height: 10))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
            layer.borderWidth = 0.7
            layer.borderColor = AppDelegate.linecolor.cgColor//UIColor.lightGray.cgColor
            layer.cornerRadius = TwoCorners
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable var RightTwoCorners: CGFloat = 0.0{
        didSet {
            let corners: UIRectCorner = [.topLeft, .bottomRight]//[.topRight, .bottomLeft]
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 10, height: 10))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
            layer.borderWidth = 0.7
            layer.borderColor = AppDelegate.linecolor.cgColor//UIColor.lightGray.cgColor
            layer.cornerRadius = RightTwoCorners
            layer.maskedCorners =  [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        }
    }
    
}
@IBDesignable
class ButtonRound: UIButton{
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var Dropshadow: Bool = false {
        didSet {
            self.dropShadow2(color: .darkGray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        }
    }
    
    @IBInspectable var ApplyGradiant: Bool = false {
        
        didSet {
//            self.applyGradient(colours: [#colorLiteral(red: 0.4155262411, green: 0.7255352139, blue: 0.8626369834, alpha: 1), #colorLiteral(red: 0.3370283246, green: 0.7451410294, blue: 0.7685293555, alpha: 1)],locations: [0,1])
            
        self.applyGradient2(withColours:  [#colorLiteral(red: 0.4155262411, green: 0.7255352139, blue: 0.8626369834, alpha: 1), #colorLiteral(red: 0.3370283246, green: 0.7451410294, blue: 0.7685293555, alpha: 1)], gradientOrientation: GradientOrientation.topLeftBottomRight)
        }
    }
  
    func applyGradient1(withColours colours: [UIColor], locations: [NSNumber]? = nil) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        self.Dropshadow = true
        self.clipsToBounds = true
        self.layer.cornerRadius = self.cornerRadius
    }
    
    func applyGradient2(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
        self.Dropshadow = true
        self.clipsToBounds = true
        self.layer.cornerRadius = self.cornerRadius
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
        self.clipsToBounds = true
        self.layer.cornerRadius = self.cornerRadius
//        self.Dropshadow = true
    }

    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        self.clipsToBounds = true
        self.layer.cornerRadius = self.cornerRadius
//        self.Dropshadow = true
    }
    
    @IBInspectable var TwoCorners: CGFloat = 0.0 {
        didSet {
            let corners: UIRectCorner = [.topLeft, .bottomRight]
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 0, height: 0))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
            layer.borderWidth = 0.7
            layer.borderColor = AppDelegate.linecolor.cgColor//UIColor.lightGray.cgColor
            
            layer.cornerRadius = 40
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    @IBInspectable var RightTwoCorners: CGFloat = 0.0{
        didSet {
            let corners: UIRectCorner = [.topRight, .bottomLeft]
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 0, height: 0))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
            layer.borderWidth = 0.7
            layer.borderColor = AppDelegate.linecolor.cgColor//UIColor.lightGray.cgColor
            
            layer.cornerRadius = RightTwoCorners
            //            layer.maskedCorners =  [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
            
            layer.maskedCorners =  [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        }
    }
    
   
}



typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    
    var startPoint: CGPoint {
        return points.startPoint
    }
    
    var endPoint: CGPoint {
        return points.endPoint
    }
    
    var points: GradientPoints {
        switch self {
        case .topRightBottomLeft:
            return (CGPoint.init(x: 0.0, y: 1.0), CGPoint.init(x: 1.0, y: 0.0))
        case .topLeftBottomRight:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 1, y: 1))
        case .horizontal:
            return (CGPoint.init(x: 0.0, y: 0.5), CGPoint.init(x: 1.0, y: 0.5))
        case .vertical:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 0.0, y: 1.0))
        }
    }
}




extension UIView
{
    
   
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize
    {
        get
        {
            return layer.shadowOffset
        }
        set
        {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor?
    {
        get
        {
            if let color = layer.shadowColor
            {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set
        {
            if let color = newValue
            {
                layer.shadowColor = color.cgColor
            }
            else
            {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIView
{
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float)
    {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}



extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable var boarderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get{
            return  self.boarderColor
        }
     }
    
    @IBInspectable var borderWidth : CGFloat {
       set {
           layer.borderWidth = newValue
       }

       get {
           return layer.borderWidth
       }
   }
    
    @IBInspectable var cornerRadius : CGFloat {
      set {
          layer.cornerRadius = newValue
      }

      get {
          return layer.cornerRadius
      }
  }
}



@IBDesignable
class RoundUIImage: UIImageView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}
