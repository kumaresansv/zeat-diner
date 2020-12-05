//
//  RestaurantTableCell.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 12/30/16.
//  Copyright © 2016 Zeat. All rights reserved.
//

import UIKit

class RestaurantTableCell: UITableViewCell {

    @IBOutlet weak var restaurantImage: UIImageView!
    
    @IBOutlet weak var restaurantName: UILabel!
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!
    
//    var dineInAction: ((UITableViewCell) -> Void)?
    
//    @IBAction func dinIn(_ sender: Any) {
//        dineInAction?(self)
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.contentView.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
