//
//  Node.swift
//  Tree
//
//  Created by Wajih Invotyx on 20/09/2019.
//  Copyright © 2019 Wajih. All rights reserved.
//

import UIKit

class Node: UIView {

    @IBOutlet weak var FirstName: UILabel!
    @IBOutlet weak var secName: UILabel!
    @IBOutlet weak var DOB: UILabel!
    @IBOutlet weak var userImage: RoundUIImage!
    
    @IBOutlet weak var nodeViewAdd: RoundUIView!
    @IBOutlet weak var plusimg: UIImageView!
    @IBOutlet weak var plusbtn: MyButton!
    @IBOutlet weak var EditNode: MyButton!
    func isPlusHidden(is flag:Bool)  {
        nodeViewAdd.isHidden = flag
        plusimg.isHidden = flag
        plusbtn.isHidden = flag
    }
    
}
