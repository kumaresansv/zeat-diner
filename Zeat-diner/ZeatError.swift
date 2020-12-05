//
//  ZeatError.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/17/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation

class ZeatError: Error {
    var errorMessage: String?
    var errorTitle: String?
    var afterErrorAction: String?
    
    init(errorTitle: String?, errorMessage: String?) {
        if let errorMessage = errorMessage {
            self.errorMessage = errorMessage
        }

        if let errorTitle = errorTitle {
            self.errorTitle = errorTitle
        }

    }
}
