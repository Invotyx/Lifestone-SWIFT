//
//  MyAlerts.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 17/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import Foundation
import UIKit

/////// Alerts functions ///
func alert2(view: UIViewController){
    let alert = UIAlertController(title: "Alert", message: "Please check your network and try again", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
    }))
    view.present(alert, animated: true, completion: nil)
}

func alert(view: UIViewController,msg:String)  {
    let message = msg
    let alert = UIAlertController(title: "Alert", message: "View is Under Construction", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
        print(message)
    }))
    view.present(alert, animated: true, completion: nil)
}

func alert3(view: UIViewController,msg:String)  {
    let message = msg
    let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
        print(message)
    }))
    view.present(alert, animated: true, completion: nil)
}
