//
//  HomeTableViewCell.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 07/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblactive: UILabel!
    @IBOutlet weak var lbldes: UILabel!
    @IBOutlet weak var vw: UIView!
    
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
