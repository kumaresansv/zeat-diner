//
//  ItemOptionTableViewCell.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 4/24/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit
import Eureka

public struct Option: Equatable {
    var name: String
    var price: String
}

public func ==(lhs: Option, rhs: Option) -> Bool {
    return lhs.name == rhs.name
}




final class ItemOptionCell : Cell<Option>, CellType {
    
    @IBOutlet weak var selectImage: UIImageView!
    
    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var optionPrice: UILabel!
    
    lazy public var trueImage: UIImage = {
        return #imageLiteral(resourceName: "selectedRadioBox")
    }()
    
    lazy public var falseImage: UIImage = {
        return #imageLiteral(resourceName: "unselectedRadioBox")
    }()
    
    public override func setup() {
        super.setup()
        selectionStyle = .none
    }
    
    public override func update() {
        super.update()
        accessoryType = .none
        selectImage?.image = row.value != nil ? trueImage : falseImage
        
    }
    
    public func disableCell() {
        isUserInteractionEnabled = false
        optionName.textColor = UIColor.gray
        optionPrice.textColor = UIColor.gray
        selectImage.image = #imageLiteral(resourceName: "disabledCheckBox")
        falseImage = #imageLiteral(resourceName: "disabledCheckBox")
    }

    public func enableCell() {
        isUserInteractionEnabled = true
        optionName.textColor = UIColor.black
        optionPrice.textColor = UIColor.black
        selectImage.image = #imageLiteral(resourceName: "unselectedCheckBox")
        falseImage = #imageLiteral(resourceName: "unselectedCheckBox")
    }

}

final class ItemOptionRow: Row<ItemOptionCell>, SelectableRowType,  RowType {
    public var selectableValue: Option?
    
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<ItemOptionCell>(nibName: "ItemOptionCell")
    }
}



