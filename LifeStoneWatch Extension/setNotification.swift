//
//  setNotification.swift
//  
//
//  Created by Wajih Invotyx on 11/02/2020.
//

import UIKit
import UserNotifications

class Notification_Handler
{
    lazy var dateFormatter: DateFormatter =
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd'/'MM'/'yyyy"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    lazy var timeFormatter: DateFormatter =
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    
    
   
    func tiggerNoti()
    {
//        check user default
        let UD_Date = UserDefaults.standard.string(forKey:"UD_Date") ?? ""
        
        if UD_Date ==  ""
        {
            print("1")
           manageNoti(StartData: Date())
        }
        else
        {
            // calc difference of twi dates
            print("2")
            let diff = calcDateDifference(StartDate: Date(), EndDate: dateFormatter.date(from: UD_Date) ?? Date())
            print(diff)
            if diff < 5
            {
                print("3")
                manageNoti(StartData: dateFormatter.date(from: UD_Date) ?? Date())
            }
        }
    }
    func manageNoti(StartData:Date)
    {
        // add and set noti of 55 days
        
        var nextDate = StartData
        print("13")
        for i in 0..<listofNotifications.count
        {
            let notification = listofNotifications[i]
            
            let dd = dateFormatter.string(from: nextDate).split(separator: "/")
            let datte:Int = Int(dd[0]) ?? -1
            let month:Int = Int(dd[1])!
            let year:Int = Int(dd[2])!
            
            let tt = timeFormatter.string(from: nextDate).split(separator: ":")
            let hour:Int = Int(tt[0]) ?? 10
            var min:Int = Int(tt[1]) ?? 00
            if min < 58{
                min = min + 1
            }
            if datte == -1{
                return
            }
            
            let endComp = DateComponents(year: year, month: month, day: datte ,hour: hour ,minute: min)
            
            print(endComp)
            
            triggerNotification(datecomponent: endComp, Body: notification)
            
            nextDate = getNextDate(preDate: nextDate)
        }
        UserDefaults.standard.set(dateFormatter.string(from: nextDate), forKey: "UD_Date")
        
     //   print(UserDefaults.standard.string(forKey: "UD_Date"))
    }
    
    func getRendom() -> Int
    {
        let number = Int.random(in: 0..<listofNotifications.count)
        return number
    }
    
    func calcDateDifference(StartDate:Date,EndDate:Date) -> Int
    {
        let interval = EndDate - StartDate
        
        return interval.day ?? 0
    }
    
    func getNextDate(preDate:Date) -> Date
    {
        let Ndate = Calendar.current.date(byAdding: .minute, value: 1, to: preDate) ?? Date()
        print(Ndate)
        return Ndate
    }
   
    func triggerNotification(datecomponent:DateComponents,Body:String)
    {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        
        content.title = "Life Stone"
        
        content.subtitle = ""
        
        content.body = Body
        
        content.badge = 1
        
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponent, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        print("Trigger")
        center.add(request)
        { (error) in
            print(error as Any)
        }
    }
    
    
    
    
}
class noti {
    var title = ""
    var body = ""
    init(title:String,body:String)
    {
        self.title = title
        self.body = body
    }
}


extension Date {
    
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
        
        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
}

