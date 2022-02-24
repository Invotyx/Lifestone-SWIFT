//
//  MyUser.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 17/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import Foundation
import UIKit


class UserInfo: NSObject,NSCoding{
    var id: String
    var token : String
    var email, phoneNumber, firstName, lastName,dob, status, city, pass,gender,profileImage,lifestones_count,charities_count,subscription,created_at,display_image: String
    
    override init() {
        id = ""
        token = ""
        email = ""
        phoneNumber = ""
        firstName = ""
        lastName = ""
        status = ""
        city = ""
        gender = ""
        profileImage = ""
        dob = ""
        pass = ""
        lifestones_count = ""
        charities_count = ""
        subscription = ""
        created_at = ""
        display_image = ""
    }
    
    init(token : String,id: String, email: String, phoneNumber: String, firstName: String, lastName: String, dob: String, status: String, city: String, gender: String, profileImage: String,pass: String, lifestones_count: String, charities_count: String,subscription: String, created_at: String,display_image: String) {
        self.token = token    
        self.id = id
        self.email = email
        self.phoneNumber = phoneNumber
        self.firstName = firstName
        self.lastName = lastName
        self.dob = dob
        self.status = status
        self.city = city
        self.gender = gender
        self.profileImage = profileImage
        self.pass = pass
        self.lifestones_count = lifestones_count
        self.charities_count = charities_count
        self.subscription = subscription
        self.created_at = created_at
        self.display_image = display_image
    }

    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(token, forKey: "token")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(profileImage, forKey: "profileImage")
        aCoder.encode(pass, forKey: "pass")
        aCoder.encode(lifestones_count, forKey: "lifestones_count")
        aCoder.encode(charities_count, forKey: "charities_count")
        aCoder.encode(subscription, forKey: "subscription")
        aCoder.encode(created_at, forKey: "created_at")
        aCoder.encode(display_image, forKey: "display_image")
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let Mytoken = aDecoder.decodeObject(forKey: "token") as! String
        let myuserId = aDecoder.decodeObject(forKey: "id") as! String
        let myemail = aDecoder.decodeObject(forKey: "email") as! String
        let myphone_number = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        let myfirst_name = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastname = aDecoder.decodeObject(forKey: "lastName") as! String
        let mydob = aDecoder.decodeObject(forKey: "dob") as! String
        let Mystatus = aDecoder.decodeObject(forKey: "status") as! String
        let Myarea = aDecoder.decodeObject(forKey: "city") as! String
        let Mygender = aDecoder.decodeObject(forKey: "gender") as! String
        let myprofile_image = aDecoder.decodeObject(forKey: "profileImage") as! String
        let mypass = aDecoder.decodeObject(forKey: "pass") as! String
        let mylifestones_count = aDecoder.decodeObject(forKey: "lifestones_count") as! String
        let mycharities_count = aDecoder.decodeObject(forKey: "charities_count") as! String
        let mysubscription = aDecoder.decodeObject(forKey: "subscription") as! String
        let mycreated_at = aDecoder.decodeObject(forKey: "created_at") as! String
        let mydisplay_image = aDecoder.decodeObject(forKey: "display_image") as! String
        
        self.init(token: Mytoken, id: myuserId, email: myemail, phoneNumber: myphone_number, firstName: myfirst_name, lastName: lastname, dob: mydob,status : Mystatus,city : Myarea,gender:Mygender,profileImage:myprofile_image,pass: mypass,lifestones_count:mylifestones_count,charities_count:mycharities_count,subscription:mysubscription,created_at:mycreated_at,display_image:mydisplay_image)
        
    }
}
//// save read user data /////
func Read_UD()  -> UserInfo {
    var data = UserInfo()
    if let DataFromCache = UserDefaults.standard.object(forKey: "SavedPersonalInfo") as? Data  {
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: DataFromCache) as? UserInfo ?? UserInfo()
        data = decodedTeams
    }
    return data
}
func Save_UD(info: UserInfo)   {
    let userdefault = UserDefaults.standard
    let encodeData:Data = NSKeyedArchiver.archivedData(withRootObject: info)
    userdefault.set(encodeData, forKey: "SavedPersonalInfo")
    userdefault.synchronize()
}
