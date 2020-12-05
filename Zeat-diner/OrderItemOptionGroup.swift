//
//  DiningTable.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation

class OrderItemOptionGroup: Codable {
    
    var optionGroupName: String?
    var optionGroupType: String?
    var itemOptionValues: [OrderItemOptionValue]?
    
    enum CodingKeys: String, CodingKey {
        case optionGroupName = "name"
        case optionGroupType = "type"
        case itemOptionValues
    }
}

