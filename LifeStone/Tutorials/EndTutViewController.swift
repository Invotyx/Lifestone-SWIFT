//
//  EndTutViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 08/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit

class EndTutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backSwipe(_ sender: UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "backnext", sender: nil)
    }
    
    @IBAction func btnGetStarted(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            UserDefaults.standard.set("no", forKey: "first")
            self.performSegue(withIdentifier: "proceed", sender: nil)
        }else{
            print("Internet Connection not Available!")
            UserDefaults.standard.set("no", forKey: "first")
            self.performSegue(withIdentifier: "first", sender: nil)
        }
    }
    
}
