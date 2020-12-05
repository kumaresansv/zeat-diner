//
//  DiningTable.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation

class MenuItem: Codable {
    
    var itemName: String?
    var itemDescription: String?
    var sequence: Int?
    var active: Bool?
    var itemPrice: String?
    var calories: Int?
    var heatIndex: String?
    var allergyInformation: String?
    var allergyInformationAllergens: String?
    var vegetarian: String?
    var vegan: String?
    var kosher: String?
    var halal: String?
    var glutenFree: String?
    var itemOptionGroups: [MenuItemOptionGroup] = []
    var id: String?

    enum CodingKeys: String, CodingKey {
        case itemName = "name"
        case itemDescription = "description"
        case sequence
        case active
        case itemPrice = "price"
        case calories
        case heatIndex
        case allergyInformation
        case allergyInformationAllergens
        case vegetarian
        case vegan
        case kosher
        case halal
        case glutenFree
        case itemOptionGroups
        case id
    }

}
