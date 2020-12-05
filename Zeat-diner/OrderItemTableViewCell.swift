//
//  OrderItemTableViewCell.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 12/20/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel?
    @IBOutlet weak var itemOptionLabel: UILabel?
    @IBOutlet weak var itemPriceLabel: UILabel?
    @IBOutlet weak var itemStatusLabel: UILabel?


    @IBOutlet weak var dinerImageView: UIImageView?
    @IBOutlet weak var itemCountImageView: UIImageView?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
