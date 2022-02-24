//
//  SelectLifestoneforViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 07/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var objpop2 = SelectLifestoneforViewController()
import UIKit

class SelectLifestoneforViewController: UIViewController {
    
    @IBOutlet weak var btback: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        objpop2 = self
    }
  
    
    func userDismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnback(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
