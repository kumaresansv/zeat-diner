//
//  Order.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation

class Order: Codable {
    var orderId: String?
    var orderStatus: String?
    var orderType: String?
    var orderDate: Date?
    var groupName: String?
    var groupCount: Int?
    var diners: [Diner]?
    var items: [OrderItem]?
    var table: DiningTable?
    var restaurant: Restaurant?
    var diner: Diner? // Used to create Json for New Order

    enum CodingKeys: String, CodingKey {
        case orderId
        case orderStatus
        case orderType
        case orderDate
        case groupName
        case groupCount
        case diners
        case items
        case diner
        case table
        case restaurant
    }
    
    init(groupName: String, groupCount: Int, orderDate: Date, diner: Diner, restaurant: Restaurant) {
        self.groupName = groupName
        self.groupCount = groupCount
        self.orderDate = orderDate
        self.diner = diner
        self.restaurant = restaurant
    }

    func dinerNames() -> String {
        var dinerNames: [String] = []
        
        for diner in self.diners! {
            if let dinerName = diner.nickname {
                dinerNames.append(dinerName)
            }
        }
        return dinerNames.joined(separator: ", ")
    }
    
}
