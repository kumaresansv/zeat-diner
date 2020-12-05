//
//  DiningTable.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation

class MenuSection: Codable {
    
    var sectionName: String?
    var sectionDescription: String?
    var sequence: Int?
    var active: Bool?
    var subsections: [MenuSubsection] = []
    var id: String?

    enum CodingKeys: String, CodingKey {
        case sectionName = "name"
        case sectionDescription = "description"
        case sequence
        case active
        case subsections
        case id
    }
}
