
//
//  MediaDetailsTableViewCell.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 18/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit

class MediaDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var img: RoundUIImage!
    @IBOutlet weak var lbltitle: UILabel!
    
    @IBOutlet weak var lblCreatedAt: UILabel!
    @IBOutlet weak var lbldes: UILabel!
    
    @IBOutlet weak var btndel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
