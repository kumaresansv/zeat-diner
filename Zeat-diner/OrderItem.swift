//
//  OrderDetail.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 5/9/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation

class OrderItem: Codable  {
    
    var orderId: String?
    var orderItemId: String?
    var restaurantId: String?
    var itemQuantity: Int?
    var itemId: String?
    var itemPrice: String?
    var itemName: String?
    var itemStatus: Int?
    var itemStatusDescription: String?
    var itemOptionPrice: String?
    var totalPrice: String?
    var dinerId: String?
    var itemSpecialInstructions: String?
    var itemOptionGroups: [OrderItemOptionGroup]?
    
    enum CodingKeys: String, CodingKey {
        case orderId
        case orderItemId
        case restaurantId
        case itemQuantity
        case itemId
        case itemPrice
        case itemName
        case itemStatus = "orderItemStatus"
        case itemStatusDescription = "orderItemStatusDescription"
        case itemOptionPrice
        case itemOptionGroups
        case totalPrice = "orderItemTotalPrice"
        case dinerId
        case itemSpecialInstructions
    }

    func options() -> String {
        var options: [String] = []

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current

        itemOptionGroups?.forEach({ (optionGroup) in
            optionGroup.itemOptionValues?.forEach({ (optionValue) in
                if (optionValue.optionValuePrice!.doubleValue > 0.0) {
                    let optionPrice = numberFormatter.string(from: NSNumber(value: optionValue.optionValuePrice!.doubleValue))
                    options.append(optionValue.optionValueName! + " (" + optionPrice! + ")")

                } else {
                    options.append(optionValue.optionValueName!)
                }
            })
        })
        
        return options.joined(separator: "\n")
    }

    

}
