//
//  NoNetworkViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 17/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit

class NoNetworkViewController: UIViewController {

    @IBOutlet weak var btntry: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btntry.dropShadow2(color: .darkGray, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
    }
    
    @IBAction func btnTryAgain(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
           updateRootView()
        }else{
            (sender as! UIButton).shake(duration: 0.5, values: [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0])
        }
    }
    
}
