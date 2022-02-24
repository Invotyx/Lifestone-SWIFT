//
//  SelfLifeStoneViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 27/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit

class SelfLifeStoneViewController: AMPagerTabsViewController1 {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UserLoad()
    }
    
    func UserLoad(){
        
     
        settings.tabBackgroundColor = #colorLiteral(red: 0.1058022752, green: 0.2549206316, blue: 0.337208569, alpha: 1)
        settings.tabButtonColor = #colorLiteral(red: 0.1058022752, green: 0.2549206316, blue: 0.337208569, alpha: 1)
        
        tabFont = UIFont(name:"Roboto-Regular", size: 12.0)!//UIFont.systemFont(ofSize: 17, weight: .bold)
        settings.top = false
        self.viewControllers = getTabs()
    }
    
    func getTabs() -> [UIViewController]{
        // instantiate the viewControllers
        var arr:[UIViewController] = []
        let About = self.storyboard?.instantiateViewController(withIdentifier: "FollwerAboutViewController")
        About?.title = "About"
        arr.append(About!)
        let Media = self.storyboard?.instantiateViewController(withIdentifier: "FollwerMediaViewController")
        Media?.title = "Media"
        arr.append(Media!)
        let SportedCharity = self.storyboard?.instantiateViewController(withIdentifier: "FollowerSportedCharityViewController")
        SportedCharity?.title = "Supported Charity"
        arr.append(SportedCharity!)
        
        let Goals = self.storyboard?.instantiateViewController(withIdentifier: "FollowerGoalsViewController")
        Goals?.title = "Goals"
        arr.append(Goals!)
        
        let LastWishes = self.storyboard?.instantiateViewController(withIdentifier: "FollowerLastWishesViewController")
        LastWishes?.title = "Last Wishes"
        arr.append(LastWishes!)
        
        let EnventAndActivites = self.storyboard?.instantiateViewController(withIdentifier: "FollowerEnventAndActivitesViewController")
        EnventAndActivites?.title = "Envent/Activites"
        arr.append(EnventAndActivites!)
        
        return arr
    }

}
