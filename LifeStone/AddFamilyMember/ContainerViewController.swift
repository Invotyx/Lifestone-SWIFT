//
//  ContainerViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 30/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var objContainer = ContainerViewController()
import UIKit
import SideMenu
class ContainerViewController: UIViewController {

    var hamshown2 = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        objContainer = self
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        UserLoadData()
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        UserLoadData()
//    }
    
//    func UserLoadData(){
////        self.tabBarController?.tabBar.isHidden = false
////        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
////        self.navigationController?.navigationBar.isTranslucent = true
////        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.6039215686, blue: 0.8274509804, alpha: 1)
////        let nav = self.navigationController?.navigationBar
////        nav?.tintColor = UIColor.white
////        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//    }
    
    @IBAction func btnham(_ sender: UIBarButtonItem) {
        if !hamshown2{
            self.performSegue(withIdentifier: "shoeleft", sender: nil)
        }
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnMan(_ sender: UIButton) {
        alert(view: self, msg: "")
    }
    
}

