//
//  EventTableViewCell.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 16/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var btnRsvp: UIButton!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var btnDel: UIButton!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var iconisgoing: UIImageView!
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblduration: UILabel!
    @IBOutlet weak var lbldes: UILabel!
    
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblmap: UILabel!
    @IBOutlet weak var lbltime: UILabel!
//    @IBOutlet weak var height: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
