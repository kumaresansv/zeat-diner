//
//  ZeatErrorTypes.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 11/21/16.
//  Copyright © 2016 Zeat. All rights reserved.
//

import Foundation

//public enum ZeatServiceError: Error {
//    case systemError
//    case authError(reason: String)
//    case objectSerialization(loginStatus: Bool)
//}

public enum ZeatLoginError: Error {
    case systemError
    case authError(reason: String)
    case errorStatus(message: String)
    case dinerSerialization(loginStatus: Bool)
}



