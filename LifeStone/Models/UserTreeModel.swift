//
//  UserTreeModel.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 24/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
import Foundation
import UIKit

enum role: Int{
    case patner = 5
    case father = 1
}

class line_pt{
    var startPt = CGPoint.zero
    var endPts:[CGPoint] = []
    init() {
        startPt = CGPoint.zero
        endPts = []
    }
    init(st:CGPoint,enpt:[CGPoint]) {
        startPt = st
        endPts = enpt
    }
}

class FamilyTree{
    var title = ""
    var id = 12
    var roleID = 0
    var tree_id = 1
    var f_name = "wajiha"
    var l_name = "hassan"
    var email = ""
    var gender = "male"
    var about = "he is a sonr to me"
    var dob = "1995-04-02"
    var is_alive = 0
    var departure_date = ""
    var image = "image_1569240205.jpeg"
    var thumbnail = ""
    var level = 1
    var created_at = "2019-09-23 12:03:25"
    var updated_at = "2019-09-23 12:03:25"
    var deleted_at = ""
    var user_id = -1
    var relatives: [FamilyTree] = []
    
    init() {
        title = ""
        id = -1
        roleID = -1
        tree_id = -1
        f_name = ""
        l_name = ""
        email = ""
        gender = ""
        about = ""
        dob = ""
        is_alive = 0
        departure_date = ""
        image = ""
        thumbnail = ""
        level = 1
        created_at = ""
        updated_at = ""
        deleted_at = ""
        user_id = -1
        relatives = []
    }
    
    init(data:FamilyTree) {
        title = data.title
        id = data.id
        roleID = data.roleID
        tree_id = data.tree_id
        f_name = data.f_name
        l_name = data.l_name
        email = data.email
        gender = data.gender
        about = data.about
        dob = data.dob
        is_alive = data.is_alive
        departure_date = data.departure_date
        image = data.image
        thumbnail = data.thumbnail
        level = data.level
        created_at = data.created_at
        updated_at = data.updated_at
        deleted_at = data.deleted_at
        user_id = data.user_id
        relatives = data.relatives
    }
    
}

