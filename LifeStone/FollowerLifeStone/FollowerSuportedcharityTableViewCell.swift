//
//  FollowerSuportedcharityTableViewCell.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 14/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit

class FollowerSuportedcharityTableViewCell: UITableViewCell {
    @IBOutlet weak var bkimg: RoundUIImage!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lbldes: UILabel!
    @IBOutlet weak var btndonate: UIButton!
    @IBOutlet weak var btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
