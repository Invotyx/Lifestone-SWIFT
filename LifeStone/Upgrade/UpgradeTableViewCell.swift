//
//  UpgradeTableViewCell.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 05/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit

class UpgradeTableViewCell: UITableViewCell {
    @IBOutlet weak var lblttile: UILabel!
    @IBOutlet weak var btnradio: UIButton!
    
    @IBOutlet weak var lblprice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
