//
//  PaymentDetailTableViewCell.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 05/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit

class PaymentDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var btndelete: UIButton!
    @IBOutlet weak var lblexpiry: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblcardno: UILabel!
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
