//
//  lineVCViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 24/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit

class lineVCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        PlotLine(startPoint: CGPoint(x: 40, y: 40),EndPoint:CGPoint(x: 300, y: 300))
        PlotLine(startPoint: CGPoint(x: 300, y: 40),EndPoint:CGPoint(x: 40, y: 300))
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.clear()
        }
        
    }
    func clear()  {
        self.view.layer.sublayers = nil
    }
    func PlotLine(startPoint:CGPoint,EndPoint:CGPoint)  {
        if startPoint.y > EndPoint.y{
            // mean invalid line
         return
        }
        if startPoint.x == EndPoint.x{
             drawLine(startPoint:startPoint,EndPoint:EndPoint, inView: self.view)
        }
        else if startPoint.x < EndPoint.x{
            let midY:CGFloat = startPoint.y + CGFloat(abs(startPoint.y - EndPoint.y)/2)
            let midX2 = startPoint.y + CGFloat(abs(startPoint.x - EndPoint.x))
            
            drawLine(startPoint: startPoint, EndPoint: CGPoint(x: startPoint.x, y: midY), inView: self.view)
            drawLine(startPoint: CGPoint(x: startPoint.x, y: midY), EndPoint: CGPoint(x: midX2, y: midY), inView: self.view)
            drawLine(startPoint: CGPoint(x: midX2, y: midY), EndPoint: EndPoint, inView: self.view)
            
            print("On Right Side")
        }
        else if startPoint.x > EndPoint.x{
            let midY:CGFloat = startPoint.y + CGFloat(abs(startPoint.y - EndPoint.y)/2)
            let midX2 = CGFloat(abs(EndPoint.x))
            
            drawLine(startPoint: startPoint, EndPoint: CGPoint(x: startPoint.x, y: midY), inView: self.view)
            drawLine(startPoint: CGPoint(x: startPoint.x, y: midY), EndPoint: CGPoint(x: midX2, y: midY), inView: self.view)
            drawLine(startPoint: CGPoint(x: midX2, y: midY), EndPoint: EndPoint, inView: self.view)
            print("On Lift Side")
        }
    }
    
    func drawLine(startPoint:CGPoint,EndPoint:CGPoint, inView view: UIView) {
        
        let lineColor: UIColor = .lightGray
        let lineWidth: CGFloat = 1
        
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: EndPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        
        view.layer.addSublayer(shapeLayer)
        
    }
    

}
