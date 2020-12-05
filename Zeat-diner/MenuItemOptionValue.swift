//
//  DiningTable.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation

class MenuItemOptionValue: Codable  {
    
    var optionObjectName: String?
    var optionObjectPrice: String?
    var sequence: Int?
    var isDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case optionObjectName = "name"
        case optionObjectPrice = "price"
        case sequence
        case isDefault
    }   
}

