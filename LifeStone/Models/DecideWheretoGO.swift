//
//  DecideWheretoGO.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 17/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import Foundation
import UIKit


func updateRootView(){
    
    let status = UserDefaults.standard.bool(forKey: "loginstatus")
    var rootVC : UIViewController?
    AppDelegate.NotificationCount = UserDefaults.standard.integer(forKey: "NotificationCount")
    AppDelegate.firsTime =  UserDefaults.standard.string(forKey: "first") ?? "yes"
    if AppDelegate.firsTime == "yes"{
        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartScreen123") as! StartScreen123
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }else{
        if !Reachability.isConnectedToNetwork(){
//            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoNetworkViewController")as! NoNetworkViewController
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = rootVC
        }else{
            if(status){
                rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = rootVC
            }
            else{
                rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Start")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = rootVC
            }
            
        }
    }
    
}
