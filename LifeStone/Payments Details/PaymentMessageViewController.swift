//
//  PaymentMessageViewController.swift
//  LifeStone
//
//  Created by Hammas Naik on 04/08/2020.
//  Copyright © 2020 Invotyx. All rights reserved.
//

import UIKit

class PaymentMessageViewController: UIViewController
{

    @IBOutlet weak var lblmessage: UILabel!
    @IBOutlet weak var subHeading: UILabel!
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var btnTitle: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var btn1: UIButton!
    
    
    var isError = false
    var titles = ""
    var subTitle = ""
    var msg = ""
    
    @IBOutlet weak var dismis: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if isError == true
        {
            lblTitle.textColor  = UIColor.red
            btn.backgroundColor = UIColor.red.withAlphaComponent(0.6)
            lblTitle.text    = titles
            lblmessage.text  = msg
            subHeading.text  = subTitle
            Img.image        = #imageLiteral(resourceName: "Errorrs")
            btnTitle.isHidden = true
            btn.isHidden     = true
            btn1.isHidden    = false
        }
        else
        {
            lblTitle.text    = titles
            lblmessage.text  = msg
            subHeading.text  = subTitle
            Img.image        = UIImage(named: "noname")
            btnTitle.isHidden = false
            btn.isHidden     = false
            btn1.isHidden    = true
        }
    }
    

    @IBAction func dismis(_ sender: UIButton)
    {
        self.dismiss(animated: true)
        {
            objpay.viewWillAppear(false)
        }
    }
    

}
