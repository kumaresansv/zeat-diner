//
//  ItemOptionHeader.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 4/27/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit

class ItemOptionHeader: UIView {
    
    
    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var required: UILabel!
    
    var optionMinimum: Int = 0
    var optionMaximum: Int = 0
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
