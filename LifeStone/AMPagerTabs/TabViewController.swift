//
//  TabViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 20/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit


class TabViewController: AMPagerTabsViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        settings.tabBackgroundColor = #colorLiteral(red: 0.1294117647, green: 0.6039215686, blue: 0.8274509804, alpha: 1)//AppDelegate.linecolor
        settings.tabButtonColor = #colorLiteral(red: 0.1294117647, green: 0.6039215686, blue: 0.8274509804, alpha: 1)//AppDelegate.linecolor
        
        tabFont = UIFont(name:"Roboto-Regular", size: 14.0)!//UIFont.systemFont(ofSize: 17, weight: .bold)
        settings.top = true
        self.viewControllers = getTabs()
    }
        
    func getTabs() -> [UIViewController]{
        // instantiate the viewControllers
        
        var arr:[UIViewController] = []
        let Loved = self.storyboard?.instantiateViewController(withIdentifier: "ForLovedOnesViewController")
          Loved?.title = "Loved Ones"
        arr.append(Loved!)
    
        let Folow = self.storyboard?.instantiateViewController(withIdentifier: "ForFollowingsViewController")
        Folow?.title = "Following"
      arr.append(Folow!)
        
        // set the title for the tabs
      
       
    
        
        return arr//[Folow!,USer!,Loved!]
    }
    
    
   
    


}
