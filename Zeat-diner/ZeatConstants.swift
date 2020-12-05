//
//  ZeatConstants.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 5/19/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

let AWSCognitoUserPoolsSigninProviderKey = "dev-Diner"
let CognitoIdentityUserPoolRegion: AWSRegionType = .USWest2
let CognitoIdentityUserPoolId = "us-west-2_lEcoYRbom"
let CognitoIdentityUserAppClientId = "ihuv8hromj31phhul9uras3l9"
let CognitoIdentityUserAppClientSecret = ""
let ZeatCognitoIdentityPoolId = "us-west-2:47d5a378-3b93-40dd-8eeb-722273889f79"
let ZeatCognitoIdp = "cognito-idp.us-west-2.amazonaws.com/us-west-2_lEcoYRbom"

let AWSCognitoIdToken = "id-token"
let AWSAuthorization = "Authorization"
let AWSCognitoAccessToken = "access-token"
let AWSCognitoRefreshToken = "refresh-token"
let AWSExpirationTime = "token-expiration-time"

let MetersToMilesConversion = 1609.34

let ITEM_STATUS_IN_CART = 0
let ITEM_STATUS_ORDERED = 1
let ITEM_STATUS_IN_KITCHEN = 2
let ITEM_STATUS_READY = 3
let ITEM_STATUS_CANCELLED = 4
let ITEM_STATUS_DESCRIPTION = [ "In Cart", "Ordered", "In Kitchen", "Ready", "Cancelled"]
let ITEM_STATU_COLOR = [
    UIColor.init(red: 0.90, green: 0.57, blue: 0.22, alpha: 1.0),
    UIColor.init(red: 0.65, green: 0.30, blue: 0.47, alpha: 1.0),
    UIColor.init(red: 0.24, green: 0.47, blue: 0.85, alpha: 1.0),
    UIColor.init(red: 0.15, green: 0.31, blue: 0.07, alpha: 1.0),
    UIColor.init(red: 0.80, green: 0.0, blue: 0.0, alpha: 1.0)
]
