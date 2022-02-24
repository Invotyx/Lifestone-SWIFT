//
//  SetGradiant.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 22/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit

@IBDesignable
class SetGradiant:UIView{
    
    @IBInspectable var FirstColor:UIColor = UIColor.white{
        didSet{
            if vertical{
                 updateView1()
            }else{
                 updateView()
            }
        }
    }
    
    @IBInspectable var SecondColor:UIColor = UIColor.white{
        didSet{
            if vertical{
                updateView1()
            }else{
                updateView()
            }
        }
    }
    
    @IBInspectable var ThirdColor:UIColor = UIColor.white{
        didSet{
            if vertical{
                updateView1()
            }else{
                updateView()
            }
        }
    }
    
    @IBInspectable var vertical: Bool = false {
        didSet {
            if vertical{
                updateView1()
            }else{
                updateView()
            }
        }
    }
    
    override class var layerClass: AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor,SecondColor.cgColor,ThirdColor.cgColor]
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
    }
    
    func updateView1(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor,SecondColor.cgColor,ThirdColor.cgColor]
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        
//        CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
    
}

@IBDesignable
class SetTwoGradiant:UIView{
    
    @IBInspectable var FirstColor:UIColor = UIColor.white{
        didSet{
            if vertical{
                updateView1()
            }else{
                updateView()
            }
        }
    }
    
    @IBInspectable var SecondColor:UIColor = UIColor.white{
        didSet{
            if vertical{
                updateView1()
            }else{
                updateView()
            }
        }
    }
    
 
    @IBInspectable var vertical: Bool = false {
        didSet {
            if vertical{
                updateView1()
            }else{
                updateView()
            }
        }
    }
    
    override class var layerClass: AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor,SecondColor.cgColor]
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
    }
    
    func updateView1(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor,SecondColor.cgColor]
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        
        //        CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
    
}

@IBDesignable
class ButtonGradient:UIButton
{
    @IBInspectable var CornerRadius:CGFloat = 0.0{
        didSet{
            if vertical{
                updateView1()
            }else{
                updateView()

            }
            
           self.layer.cornerRadius = CornerRadius
        }
    }
    @IBInspectable var FirstColor:UIColor = UIColor.white{
        didSet{
            if vertical{
                updateView1()
            }else{
                updateView()
            }
        }
    }
    
    @IBInspectable var SecondColor:UIColor = UIColor.white{
        didSet{
            if vertical{
                updateView1()
            }else{
                updateView()
            }
        }
    }
    
    @IBInspectable var ThirdColor:UIColor = UIColor.white{
        didSet{
            if vertical{
                updateView1()
            }else{
                updateView()
            }
        }
    }
    
    @IBInspectable var vertical: Bool = false {
        didSet {
            if vertical{
                updateView1()
            }else{
                updateView()
            }
        }
    }
    
    override class var layerClass: AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    
    @IBInspectable var Dropshadow: Bool = false {
        didSet {
            self.dropShadow2(color: .darkGray, opacity: 0.3, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        }
    }
    
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor,SecondColor.cgColor,ThirdColor.cgColor]
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
    }
    
    func updateView1(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor,SecondColor.cgColor,ThirdColor.cgColor]
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        
        //        CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
    
}


@IBDesignable
class ButtonTwoGradient:UIButton
{
    
    @IBInspectable var FirstColor:UIColor = UIColor.white{
        didSet{
            if vertical{
                updateView1()
            }else{
                updateView()
            }
        }
    }
    
    @IBInspectable var SecondColor:UIColor = UIColor.white{
        didSet{
            if vertical{
                updateView1()
            }else{
                updateView()
            }
        }
    }
    
    @IBInspectable var vertical: Bool = false {
        didSet {
            if vertical{
                updateView1()
            }else{
                updateView()
            }
        }
    }
    
    override class var layerClass: AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor,SecondColor.cgColor]
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
    }
    
    func updateView1(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor,SecondColor.cgColor]
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        
    }
    
}
