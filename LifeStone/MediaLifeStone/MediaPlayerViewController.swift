//
//  MediaPlayerViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 18/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MediaPlayerViewController: UIViewController {

    var avPlayer: AVPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if MoveobjUserData.type != "image"{
            playVideo()
        }
    }
    
    func playVideo() {
        
        let videoURL = URL(string:  MoveobjUserData.imageURL)
        // Create an AVPlayer, passing it the local video url path
        
        avPlayer = AVPlayer(url: (videoURL as URL?)!)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        avPlayerController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        // Turn on video controlls
        avPlayerController.showsPlaybackControls = true
        
        // play video
        avPlayerController.player?.play()
        self.view.addSubview(avPlayerController.view)
        self.addChild(avPlayerController)
    }

}
