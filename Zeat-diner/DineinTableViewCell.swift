//
//  DineinTableViewCell.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/8/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit

class DineinTableViewCell: UITableViewCell {

    @IBOutlet weak var orderGroupInitialLabel: UILabel!
    @IBOutlet weak var orderGroupNameLabel: UILabel!
    @IBOutlet weak var orderCheckinTimeLabel: UILabel!
    @IBOutlet weak var orderGroupCountLabel: UILabel!
    @IBOutlet weak var dinerNamesLabel: UILabel!
    
//    @IBOutlet weak var dinerProfileImage1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        orderGroupInitialLabel.layer.backgroundColor = UIColor.white.cgColor
        orderGroupInitialLabel.layer.masksToBounds = true
        orderGroupInitialLabel.layer.cornerRadius = orderGroupInitialLabel.frame.width/4
        
        
        
//        dinerProfileImage1.layer.cornerRadius = dinerProfileImage1.frame.width/4
//        dinerProfileImage1.clipsToBounds = true
//        dinerProfileImage1.layer.borderWidth = 1.0
//        dinerProfileImage1.layer.borderColor = UIColor.black.cgColor
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
