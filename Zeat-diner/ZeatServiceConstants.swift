//
//  ZeatServiceConstants.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 11/18/16.
//  Copyright © 2016 Zeat. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation


class ZeatServiceConstants {

    static let baseUrl = "https://devapi.zeatit.com/"
    static let apiKey = "API_Key""
    static let baseFileUrl = "https://devfiles.zeatit.com/"

    //    static let baseUrl = "https://api.zeatit.com/"
    //    static let baseUrl = "http://api.zeat.dev/"

    static func restRequestHeaders() -> HTTPHeaders? {
        
        var header = [
            "Content-Type": "application/json",
            "x-api-key": apiKey
        ]
        
        let prefs = UserDefaults.standard
        
        if let expirationTime = prefs.object(forKey: AWSExpirationTime) as? Date {
            let currentDate = Date()
            if expirationTime < currentDate {
                // Get Token
            }
            
        }
        
        if let idToken = prefs.object(forKey: AWSCognitoIdToken) as? String {
            header[AWSAuthorization] = idToken
        }

//
//        if let client = prefs.object(forKey: ZeatUserDefaults.client) as? String {
//            header[ZeatUserDefaults.client] = client
//        }

        
//        if let accessToken = prefs.object(forKey: ZeatUserDefaults.accessToken) as? String {
//            dinerHeader[ZeatUserDefaults.accessToken] = accessToken
//        }
//
//        if let email = prefs.object(forKey: ZeatUserDefaults.email) as? String {
//            dinerHeader[ZeatUserDefaults.email] = email
//        }
        
        return header
        
    }

    static let dinerLogin = ZeatServiceConstants.baseUrl + "dinerauth/sign_in"
    static let dinerRegistration = ZeatServiceConstants.baseUrl + "dinerauth"
    static let dinerStatus = ZeatServiceConstants.baseUrl + "diner/status"
    static let dinerTokenRegistration = ZeatServiceConstants.baseUrl + "diner/diner_tokens"
    static let diner = ZeatServiceConstants.baseUrl + "diner"

    static func requestDiningTable(restaurantIdentifier zeatId: String) -> String {
        let urlString = ZeatServiceConstants.baseUrl + "orders"
//        let urlString = ZeatServiceConstants.baseUrl + "restaurants/" + "\(zeatId)" + "/request_table"
        return urlString
    }
    
    static func createNewOrder() -> String {
        let urlString = ZeatServiceConstants.baseUrl + "orders"
        return urlString
    }

    
    

    static func getMenu(restaurantIdentifier zeatId: String) -> String {
        let urlString = ZeatServiceConstants.baseUrl + "restaurants/" + "\(zeatId)" + "/menus"
        return urlString
    }

    static func searchRestaurants(location: CLLocation) -> String {
        let urlString = ZeatServiceConstants.baseUrl + "restaurants/search?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)"
        return urlString
    }
    
    
    static func endPointForRestaurantDetail(restaurantIdentifier restaurantId: String) -> String {
        let urlString = ZeatServiceConstants.baseUrl + "restaurants/" + "\(restaurantId)"
        return urlString
    }


    static func joinTable(atRestaurant zeatId: String, forOrder orderId: String) -> String {
        let urlString = ZeatServiceConstants.baseUrl + "restaurants/" + "\(zeatId)" + "/orders/" + "\(orderId)" + "/join_table"
        return urlString
    }

    
    static let platform = "iOS"

    static let ServiceStatusSuccess = "success"
    static let loggedIn = "Login"
    static let loggedOut = "LoggedOut"

    // Parameters
    static let paramZeatId = "{zeat_id}";
    
    static let menus = baseUrl + "/owner/restaurants/" + paramZeatId + "/menus"
    
}
