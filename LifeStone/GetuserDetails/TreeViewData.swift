//
//  TreeViewData.swift
//  TreeView1
//
//  Created by Cindy Oakes on 5/21/16.
//  Copyright © 2016 Cindy Oakes. All rights reserved.
//

class TreeViewData
{
    var level: Int
    var title,parentCategoriesDescription: String
    var id: String
    var parentId: String
    var isChecked:Bool
    var grandparentId:String
    var ArrayparentID: Int?
    var ArrayID: String
    init() {
        self.level = -3
        self.title = ""
        self.id = ""
        self.parentId = ""
        self.isChecked = false
        self.grandparentId = ""
        self.parentCategoriesDescription = ""
        ArrayparentID = -3
        ArrayID = ""
    }
    
    init?(level: Int, title: String, id: String,ArrayID:String, parentId: String,isChecked:Bool,grandparentId:String,parentCategoriesDescription:String,ArrayparentID:Int)
    {
        self.level = level
        self.title = title
        self.id = id
        self.parentId = parentId
        self.isChecked = isChecked
        self.grandparentId = grandparentId
        self.parentCategoriesDescription = parentCategoriesDescription
        self.ArrayparentID = ArrayparentID
        self.ArrayID = ArrayID
    }
   
}


