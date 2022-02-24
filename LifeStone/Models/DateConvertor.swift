
//
//  DateConvertor.swift
//  LifeStone
//
//  Created by Wajih on 30/06/2020.
//  Copyright © 2020 Invotyx. All rights reserved.
//

import Foundation
import UIKit

func StringtoString(userdate:String)->String
{
    let dateFormator = DateFormatter()
    dateFormator.timeZone = TimeZone.current
    dateFormator.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dtt = dateFormator.date(from: userdate) ?? Date()
    dateFormator.dateFormat = "MMM dd, yyyy HH:mm:ss"
    let sc = dateFormator.string(from: dtt)
    return sc
}


func stringtoString_with_Format(userdate:String,input:String,Output:String)->String{
    let dateFormator = DateFormatter()
    dateFormator.timeZone = TimeZone.current
    dateFormator.dateFormat = input
    let dtt = dateFormator.date(from: userdate)!
    dateFormator.dateFormat = Output
    let sc = dateFormator.string(from: dtt)
    return sc
}
