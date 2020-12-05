//
//  RestaurantMenu.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 8/12/17.
//  Copyright © 2017 Zeat. All rights reserved.
//


import Foundation

class ShortMenu: Codable {
    var name: String?
    var description: String?
    var active: Bool?
    var menuKey: String?
    var duration: [MenuDuration]?
    
//    enum CodingKeys: String, CodingKey {
//        case name
//        case description
//        case active
//        case duration
//        case menuKey
//    }
    
    func menuUrl() -> String? {
        guard let menuKey = menuKey else {
            return nil
        }
        
        let menuUrl = ZeatServiceConstants.baseFileUrl + menuKey
        
        return menuUrl
    }
    
}

