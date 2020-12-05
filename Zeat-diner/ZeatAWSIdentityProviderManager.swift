//
//  ZeatAWSIdentityProviderManager.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 6/1/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class ZeatAWSIdentityProviderManager: NSObject, AWSIdentityProviderManager {
    
    var tokens: NSDictionary?
    
    init(tokens: NSDictionary) {
        self.tokens = tokens
    }
    
    func logins() -> AWSTask<NSDictionary> {
        return AWSTask(result: tokens)
    }
    
}
