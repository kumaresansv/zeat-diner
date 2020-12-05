//
//  OrderItemRow.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 12/17/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit

class OrderItemRow: UITableViewCell {

    @IBOutlet weak var dinerNameLabel: UILabel?
    @IBOutlet weak var itemNameLabel: UILabel?

    @IBOutlet weak var dinerImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
