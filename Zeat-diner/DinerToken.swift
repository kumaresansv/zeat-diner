//
//  Diner.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 11/18/16.
//  Copyright © 2016 Zeat. All rights reserved.
//

import Foundation

class DinerToken: Codable {
    
    var token: String?
    var platform: String?
    
    init(token: String) {
        self.token = token
        self.platform = ZeatServiceConstants.platform
    }
}
