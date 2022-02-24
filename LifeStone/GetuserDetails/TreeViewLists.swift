//
//  TreeViewLists.swift
//  TreeView1
//
//  Created by Cindy Oakes on 5/21/16.
//  Copyright © 2016 Cindy Oakes. All rights reserved.
//

class TreeViewLists
{
    //MARK:  Load Array With Initial Data 
    
        
    //MARK:  Load Nodes From Initial Data
    
    static func LoadInitialNodes(_ dataList: [TreeViewData]) -> [TreeViewNode]
    {
        var nodes: [TreeViewNode] = []
        
        for data in dataList where data.level == 0
        {
             print("\(data.title)")
            
            let node: TreeViewNode = TreeViewNode()
            node.nodeLevel = data.level
            node.nodeObject = data.title as AnyObject
            node.isExpanded = GlobalVariables.TRUE
            node.nodeischecked = data.isChecked
            node.nodegrandparentId = data.grandparentId
            node.nodeparentId = data.parentId
            node.nodeOwnId = data.ArrayID
            node.nodeOwnTitle = data.title
            let newLevel = data.level + 1
            node.nodeChildren = LoadChildrenNodes(dataList, level: newLevel, parentId: data.id,grandparentid: data.grandparentId)
            
            if (node.nodeChildren?.count == 0)
            {
                node.nodeChildren = nil
            }
            
            nodes.append(node)
         
        }
        
        return nodes
    }
  
    
    //MARK:  Recursive Method to Create the Children/Grandchildren....  node arrays
    
    static func LoadChildrenNodes(_ dataList: [TreeViewData], level: Int, parentId: String,grandparentid : String) -> [TreeViewNode]
    {
        var nodes: [TreeViewNode] = []
        
        for data in dataList where data.level == level && data.parentId == parentId && data.grandparentId == grandparentid
        {
            
            print("\(data.title)")
            print("\(data.id)")
            
            let node: TreeViewNode = TreeViewNode()
            node.nodeLevel = data.level
            node.nodeObject = data.title as AnyObject
            node.isExpanded = GlobalVariables.FALSE
            node.nodeischecked = data.isChecked
            node.nodegrandparentId = data.grandparentId
            node.nodeparentId = data.parentId
            node.nodeOwnId = data.ArrayID
            node.nodeOwnTitle = data.title
            let newLevel = level + 1
            node.nodeChildren = LoadChildrenNodes(dataList, level: newLevel, parentId: data.id,grandparentid: data.grandparentId)
            
            if (node.nodeChildren?.count == 0)
            {
                node.nodeChildren = nil
            }
            
            nodes.append(node)
            
        }
        
        return nodes
    }
    
    
}
