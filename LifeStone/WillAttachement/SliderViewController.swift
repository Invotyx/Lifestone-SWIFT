//
//  SliderViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 11/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SDWebImage


class SliderViewController: UIViewController {

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet var slideshow: ImageSlideshow!
    var sdWebImageSource :[SDWebImageSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Userload()
   
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
     
    }

}




extension SliderViewController: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
    
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    func Userload(){
        
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.pageIndicator = pageControl
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self
        for item in arrimages{
            sdWebImageSource.append(SDWebImageSource(urlString: item)!)
        }
        slideshow.setImageInputs(sdWebImageSource)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        slideshow.addGestureRecognizer(recognizer)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            var moveto = -1
            for (ind,itm) in arrimages.enumerated(){
                if itm == arrAttactment[seletedIndx].imageURL{
                    moveto = ind
                    break
                }
            }
            self.slideshow.setCurrentPage(moveto, animated: true)
        })
    }
}
