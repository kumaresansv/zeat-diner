//
//  DiningTable.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation

class OrderItemOptionValue: Codable  {
    
    var optionValueName: String?
    var optionValuePrice: String?
    
    enum CodingKeys: String, CodingKey {
        case optionValueName = "name"
        case optionValuePrice = "price"
    }
}


