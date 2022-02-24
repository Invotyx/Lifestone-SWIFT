//
//  ProfileTableViewCell.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 25/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
 @IBOutlet weak var lbltitle: UILabel!
 @IBOutlet weak var txtedit: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
