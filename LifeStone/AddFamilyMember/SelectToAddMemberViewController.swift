//
//  SelectToAddMemberViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 24/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var flgAlive = false
import UIKit

class SelectToAddMemberViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnAlive(_ sender: UITapGestureRecognizer) {
        flgAlive = true
        self.performSegue(withIdentifier: "gotoad", sender: nil)
    }
    
    
    @IBAction func btnDeparted(_ sender: UITapGestureRecognizer) {
        flgAlive = false
        self.performSegue(withIdentifier: "gotoad", sender: nil)
    }
    
    @IBAction func btnCross(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
