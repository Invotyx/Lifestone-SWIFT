//
//  WillAttachmentViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 05/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit

class WillAttachmentViewController: AMPagerTabsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       UserLoad()
    }
 
    
    func UserLoad()
    {
        settings.tabBackgroundColor = #colorLiteral(red: 0.1294117647, green: 0.6039215686, blue: 0.8274509804, alpha: 1)//UIColor.clear
        settings.tabButtonColor = #colorLiteral(red: 0.1294117647, green: 0.6039215686, blue: 0.8274509804, alpha: 1)//UIColor.clear
        tabFont = UIFont(name:"Roboto-Regular", size: 14.0)!
        settings.top = true
        self.viewControllers = getTabs()
    }
    
    func getTabs() -> [UIViewController]
    {
        var arr:[UIViewController] = []
        let Loved = self.storyboard?.instantiateViewController(withIdentifier: "UserWillMediaViewController")
        Loved?.title = "Media"
        arr.append(Loved!)
        let USer = self.storyboard?.instantiateViewController(withIdentifier: "UserWillFilesViewController")
        USer?.title = "Files"
        arr.append(USer!)
        return arr
    }
    
    
}
