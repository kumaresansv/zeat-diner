//
//  DiningTable.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation

class MenuSubsection: Codable {
    
    var subsectionName: String?
    var subsectionDescription: String?
    var sequence: Int?
    var active: Bool?
    var items: [MenuItem] = []
    var id: String?


 
    enum CodingKeys: String, CodingKey {
        case subsectionName = "name"
        case subsectionDescription = "description"
        case sequence
        case active
        case items
        case id
    }   
}
