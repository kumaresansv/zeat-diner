//
//  MenuSectionHeaderViewCell.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 4/14/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit

class MenuSectionHeaderViewCell: UITableViewCell {

    @IBOutlet weak var sectionNameLabel: UILabel!
    
    @IBOutlet weak var subsectionNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.isUserInteractionEnabled = false
//        self.selection
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}
