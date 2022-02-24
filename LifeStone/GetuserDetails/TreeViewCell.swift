//
//  TreeViewCell.swift
//  TreeView1
//
//  Created by Cindy Oakes on 5/19/16.
//  Copyright © 2016 Cindy Oakes. All rights reserved.
//

import UIKit


class TreeViewCell: UITableViewCell
{
    
    //MARK:  Properties & Variables

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnleading: NSLayoutConstraint!
    @IBOutlet weak var treeButton: UIButton!
    @IBOutlet weak var treeLabel: UILabel!
    var treeNode: TreeViewNode!
  
    //MARK:  Set Background image
    
    func setTheButtonBackgroundImage(_ backgroundImage: UIImage)
    {
        self.treeButton.setBackgroundImage(backgroundImage, for: UIControl.State())
    }
    
    //MARK:  Expand Node
    
    @IBAction func expand(_ sender: AnyObject)
    {

    }
}
