//
//  DiningTable.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation

class MenuItemOptionGroup: Codable {
    
    var optionGroupName: String?
    var optionGroupType: String?
    var required: Bool?
    var sequence: Int?
    var minimum: Int?
    var maximum: Int?
    var itemOptionValues: [MenuItemOptionValue] = []

    enum CodingKeys: String, CodingKey {
        case optionGroupName = "name"
        case optionGroupType = "type"
        case required
        case sequence
        case minimum
        case maximum
        case itemOptionValues
    }   
}
