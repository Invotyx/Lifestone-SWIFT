//
//  StartScreen.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 12/02/2020.
//  Copyright © 2020 Invotyx. All rights reserved.
//

import UIKit
import ImageSlideshow

class StartScreen123: UIViewController
{

   
    //Outlets
        
    @IBOutlet weak var ImageSlider: ImageSlideshow!
    @IBOutlet weak var NextBtn: UILabel!
    @IBOutlet weak var Promotion_Lbl: UILabel!

    
        
    //Variables
    var localSource = [ImageSource(image: UIImage(named:"Square")!),ImageSource(image: UIImage(named:"Square")!),ImageSource(image: UIImage(named:"Media")!),ImageSource(image: UIImage(named:"Persons")!)
    ]
        let titletext = ["About LifeStone","Establish Family Pond","Upload Media Files","Manage Multiple Profiles"]
        let promotionText = ["Discover new ways to preserve your memories with this app.","Discover new ways to preserve your memories with this app.","Discover new ways to preserve your memories with this app.","Discover new ways to preserve your memories with this app."]
        
        
        override func viewDidLoad()
        {
            super.viewDidLoad()
            
            self.Promotion_Lbl.text = self.promotionText[0]
            self.NextBtn.text = self.titletext[0]
        }
        
        override func viewDidAppear(_ animated: Bool)
        {
             self.setupSlide()
            
             mangfe()
        }
        
        private func setupSlide()
        {
            ImageSlider.backgroundColor = UIColor.clear
            ImageSlider.slideshowInterval = 5.0
            ImageSlider.pageControlPosition = PageControlPosition.underScrollView
            ImageSlider.pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            ImageSlider.pageControl.pageIndicatorTintColor = UIColor.lightGray
            ImageSlider.contentScaleMode = UIViewContentMode.scaleAspectFit
            ImageSlider.activityIndicator = DefaultActivityIndicator()
            ImageSlider.currentPageChanged =
            { page in
                    print("current page:", page)
            }
            ImageSlider.setImageInputs(localSource)
        }
        
        func mangfe()  {
            ImageSlider.currentPageChanged = { page in
              //  self.TitlePromotion_Lbl.text = self.titletext[page]
                self.Promotion_Lbl.text = self.promotionText[page]
                self.Promotion_Lbl.text = self.titletext[page]
            }
        }
    }
