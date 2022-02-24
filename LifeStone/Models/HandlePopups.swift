//
//  HandlePopups.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 17/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import  UIKit

func addShiny(VC:UIViewController,view: UIView){
    let gradient = CAGradientLayer()
    gradient.colors = [UIColor.white.cgColor.copy(alpha: 1)! ,UIColor.lightGray.cgColor,UIColor.white.cgColor.copy(alpha: 1)!]
    gradient.locations = [0,0.5,1]
    gradient.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
    let angel = 20 * CGFloat.pi / 100
    gradient.transform = CATransform3DMakeRotation(angel, 0, 0, 1)
    view.layer.mask = gradient
    
    let animation = CABasicAnimation(keyPath: "transform.translation.x")
    animation.duration = 1.5
    animation.speed = 0.75
    animation.fromValue = -view.frame.width
    animation.toValue = view.frame.width
    animation.repeatCount = Float.infinity
    gradient.add(animation, forKey: "nothing")
    view.tintColor = UIColor.white
    
}
 /////////////  add gradient //////////////
func addGradient(VC:UIViewController,view: UIView,colors: [UIColor]){
    let gradient:CAGradientLayer = CAGradientLayer()
    gradient.frame.size = VC.view.frame.size
    gradient.colors = [UIColor.white.cgColor,UIColor.white.withAlphaComponent(0).cgColor] //Or any colors
    VC.view.layer.addSublayer(gradient)
}

func animatecenter(VC:UIViewController,Popview:UIView)  {
    VC.view.endEditing(true)
    let frame = VC.view.frame
    Popview.isHidden = false
    VC.view.addSubview(Popview)
//    Popview.layer.cornerRadius = 8
    let V_height = (frame.height*50)/100
    Popview.frame = CGRect(x: 10, y: (frame.height/2)-(V_height/2), width: frame.width-20, height: V_height)
    Popview.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
    Popview.alpha = 0
    UIView.animate(withDuration: 0.4) {
        Popview.alpha = 1
        Popview.transform = CGAffineTransform.identity
//        Popview.dropShadow2(color: .black, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
    }
}

func animate2(VC:UIViewController,Popview:UIView)  {
    VC.view.endEditing(true)
    Popview.isHidden = false
//    Popview.layer.borderColor = UIColor.lightGray.cgColor
//    Popview.layer.cornerRadius = 10
//    Popview.layer.borderWidth = 1

    VC.view.addSubview(Popview)
    let frame = VC.view.frame
    Popview.frame = CGRect(x: 0, y: frame.height, width: frame.width , height: (frame.height*70)/100)
    Popview.alpha = 0
    UIView.animate(withDuration: 0.4) {
        Popview.alpha = 1
        Popview.frame = CGRect(x: 0, y: ((frame.height*20)/100), width: frame.width, height: (frame.height*80)/100)
//        Popview.dropShadow2(color: .black, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
    }
}

func animate3(VC:UIViewController,Popview:UIView)  {
    VC.view.endEditing(true)
    Popview.isHidden = false
    VC.view.addSubview(Popview)
    let frame = VC.view.frame
    Popview.frame = CGRect(x: 0, y: -(Popview.frame.height), width: frame.width , height: (Popview.frame.height))

    Popview.alpha = 0
    UIView.animate(withDuration: 0.4) {
        Popview.alpha = 1
        Popview.frame = CGRect(x: 0, y: 0, width:  frame.width , height: (Popview.frame.height))
//        Popview.dropShadow2(color: .black, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
    }
}

func animateFull(VC:UIViewController,Popview:UIView)  {
    VC.view.endEditing(true)
    Popview.isHidden = false
    //    Popview.layer.borderColor = UIColor.lightGray.cgColor
    //    Popview.layer.cornerRadius = 10
    //    Popview.layer.borderWidth = 1
    
    VC.view.addSubview(Popview)
    let frame = VC.view.frame
    Popview.frame = CGRect(x: 0, y: frame.height, width: frame.width , height: (frame.height*70)/100)
    Popview.alpha = 0
    UIView.animate(withDuration: 0.4) {
        Popview.alpha = 1
         Popview.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)//(frame.height*80)/100
        //        Popview.dropShadow2(color: .black, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
    }
}


