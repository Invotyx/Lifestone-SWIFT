//
//  UserWillModels.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 04/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import Foundation
import UIKit

class UserWillDetails{
    var id, lsID: Int
    var fName, lName, dob, gender: String
    var image: String
    var lawyer: [Lawyer]
    var nominies: [Nominy]
    var beneficiaries: [Beneficiary]
    var confessions, custom, wishes: [Confession]
    var attachments: [Attachment]
  
    
    init() {
        self.id = 0
        self.lsID = 0
        self.fName = ""
        self.lName = ""
        self.dob = ""
        self.gender = ""
        self.image = ""
        self.lawyer = []
        self.nominies = []
        self.beneficiaries = []
        self.confessions = []
        self.custom = []
        self.wishes = []
        self.attachments = []
    }
    
    init(id: Int, lsID: Int, fName: String, lName: String, dob: String, gender: String, image: String, lawyer: [Lawyer], nominies: [Nominy], beneficiaries: [Beneficiary], confessions: [Confession], custom: [Confession], wishes: [Confession], attachments: [Attachment]) {
        self.id = id
        self.lsID = lsID
        self.fName = fName
        self.lName = lName
        self.dob = dob
        self.gender = gender
        self.image = image
        self.lawyer = lawyer
        self.nominies = nominies
        self.beneficiaries = beneficiaries
        self.confessions = confessions
        self.custom = custom
        self.wishes = wishes
        self.attachments = attachments
    }
}

// MARK: - Attachment
class Attachment {
    var id, willID: Int
    var type: String
    var imageURL: String
    var thumbURL: String
    var ischk:Bool
  
    init() {
        self.id = 0
        self.willID = 0
        self.type = ""
        self.imageURL = ""
        self.thumbURL = ""
        self.ischk = false
    }
    init(id: Int, willID: Int, type: String, imageURL: String, thumbURL: String,ischk:Bool) {
        self.id = id
        self.willID = willID
        self.type = type
        self.imageURL = imageURL
        self.thumbURL = thumbURL
        self.ischk = ischk
    }
}

// MARK: - Beneficiary
class Beneficiary {
    var id, willID: Int
    var fName, lName, dob, gender: String
    init() {
        self.id = 0
        self.willID = 0
        self.fName = ""
        self.lName = ""
        self.dob = ""
        self.gender = ""
    }
    init(id: Int, willID: Int, fName: String, lName: String, dob: String, gender: String) {
        self.id = id
        self.willID = willID
        self.fName = fName
        self.lName = lName
        self.dob = dob
        self.gender = gender
    }
}

// MARK: - Confession
class Confession {
    var id, willID: Int
    var content: String
    var title: String?
    
    init() {
        self.id = 0
        self.willID = 0
        self.content = ""
        self.title = ""

    }
    init(id: Int, willID: Int, content: String, title: String?) {
        self.id = id
        self.willID = willID
        self.content = content
        self.title = title
    }
}

// MARK: - Lawyer
class Lawyer{
    var id: Int
    var fName, lName, email: String
  
    init() {
        self.id = 0
        self.fName = ""
        self.lName = ""
        self.email = ""
    }
    
    init(id: Int, fName: String, lName: String, email: String) {
        self.id = id
        self.fName = fName
        self.lName = lName
        self.email = email
    }
}

// MARK: - Nominy
class Nominy {
    var id, willID: Int
    var fName, lName, email: String
    var priority, isMember: Int
    var invitationStatus: String
    
    init() {
        self.id = 0
        self.willID = 0
        self.fName = ""
        self.lName = ""
        self.email = ""
        self.invitationStatus = ""
        self.priority = 0
        self.isMember = 0
    }
    
    init(id: Int, willID: Int, fName: String, lName: String, email: String, priority: Int, isMember: Int, invitationStatus: String) {
        self.id = id
        self.willID = willID
        self.fName = fName
        self.lName = lName
        self.email = email
        self.priority = priority
        self.isMember = isMember
        self.invitationStatus = invitationStatus
    }
}
