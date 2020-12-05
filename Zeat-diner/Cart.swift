//
//  Order.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation

class Cart: Codable {
//    var cartDate: Date
    var restaurantId: String
    var item: [OrderItem]?
    
    
    init(forRestaurant restaurantId: String) {
        self.restaurantId = restaurantId
    }
}
