//
//  InterfaceController.swift
//  Watch-App-Sampler WatchKit Extension
//
//  Created by DCSnail on 2018/6/15.
//  Copyright © 2018年 DCSnail. All rights reserved.
//  DCSnail: https://github.com/wangyanchang21WatchOS
//  watchOS开发教程: https://blog.csdn.net/wangyanchang21/article/details/80928126
//

import WatchKit
import Foundation


class ItemListController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    let dataArray =
    {
        return
        [
             //Health/Activity
            ["image": "item_type_18", "title": "Motion Activity" , "ID": "MotionActivityController"],
            ["image": "item_type_19", "title": "Pedometer" , "ID": "PedometerController"],
            ["image": "item_type_20", "title": "Health" , "ID": "HealthController"]
        ]
    }()
    
    override func awake(withContext context: Any?)
    {
        super.awake(withContext: context)
        
        // Set Row Number And Row Type
        table.setNumberOfRows(dataArray.count, withRowType: "ItemRowController")
        
        for (i, info) in dataArray.enumerated()
        {
            let cell = table.rowController(at: i) as! ItemRowController
            cell.titleLabel.setText(info["title"])
            cell.image.setImageNamed(info["image"])
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int)
    {
        pushController(withName: dataArray[rowIndex]["ID"]!, context: dataArray[rowIndex])
    }

}
