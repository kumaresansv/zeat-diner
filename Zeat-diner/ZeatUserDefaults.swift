//
//  ZeatUserDefaults.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 11/19/16.
//  Copyright © 2016 Zeat. All rights reserved.
//

import Foundation

class ZeatUserDefaults {
    
    static let accessToken = "access-token"
    static let client = "client"
    static let email = "uid"
    static let nickName = "nick_name"
    static let phone = "phone"
    static let phoneVerified = "phone_verified"
    static let snsEndPointArn = "sns-endpoint-arn"
    static let FCMToken = "fcm_token"
    static let FCMTokenRegistrationStatus = "token_registration_status"
    static let FCMTokenDefaultValue = "No Token Registered"
    static let loginStatus = "loginStatus"
    static let orderDateTime = "orderDateTime"
    static let order = "order"
    static let lastFetchedDate = "orderFetchedDate"
    static let orderStatus = "orderStatus"
    static let dineInOrderId = "orderDetails"

    
    static let prefs = UserDefaults.standard
    
    

    static func getAccessToken () -> String {
        return prefs.object(forKey: AWSCognitoAccessToken) as? String ?? ""
    }
    
    static func setAccessToken (accessToken: String) -> Void {
        prefs.setValue(accessToken, forKeyPath: AWSCognitoAccessToken)
    }

    static func getIdToken () -> String? {
        return prefs.object(forKey: AWSCognitoIdToken) as? String
    }
    
    static func setIdToken (idToken: String) -> Void {
        prefs.setValue(idToken, forKeyPath: AWSCognitoIdToken)
    }

    static func getRefreshToken () -> String {
        return prefs.object(forKey: AWSCognitoIdToken) as? String ?? ""
    }

    static func setRefreshToken (refreshToken: String) -> Void {
        prefs.setValue(refreshToken, forKeyPath: AWSCognitoRefreshToken)
    }

    static func setExpirationTime (expirationTime: Date) -> Void {
        prefs.setValue(expirationTime, forKeyPath: AWSExpirationTime)
    }
    
    static func getExpirationTime () -> Date? {
        return prefs.object(forKey: AWSExpirationTime) as? Date
//        return prefs.object(forKey: AWSExpirationTime) as? Date ?? Date ()
    }
    
//    static func getClient () -> String {
//        return prefs.object(forKey: ZeatUserDefaults.client) as? String ?? ""
//    }
//
//    static func setClient (client: String) -> Void {
//        prefs.setValue(client, forKeyPath: ZeatUserDefaults.client)
//    }

    static func getEmail () -> String {
        return prefs.object(forKey: ZeatUserDefaults.email) as? String ?? ""
    }

    static func setEmail (email: String) -> Void {
        prefs.setValue(email, forKeyPath: ZeatUserDefaults.email)
    }
    
    static func getSNSEndpointArn () -> String? {
        return prefs.object(forKey: ZeatUserDefaults.snsEndPointArn) as? String
    }
    
    static func setSNSEndpointArn (snsEndpointArn: String) -> Void {
        prefs.setValue(snsEndpointArn, forKeyPath: ZeatUserDefaults.snsEndPointArn)
    }

    static func isLoggedIn () -> Bool {
        return prefs.object(forKey: ZeatUserDefaults.loginStatus) as? Bool ?? false
    }
    
    static func loggedIn () -> Void {
        prefs.setValue(true, forKeyPath: ZeatUserDefaults.loginStatus)
    }

    static func loggedOut () -> Void {
        prefs.setValue(false, forKeyPath: ZeatUserDefaults.loginStatus)
    }

    static func getPhone () -> String {
        return prefs.object(forKey: ZeatUserDefaults.phone) as? String ?? ""
    }
    
    static func setPhone (phone: String) -> Void {
        prefs.setValue(email, forKeyPath: ZeatUserDefaults.phone)
    }

    static func getPhoneVerified () -> String {
        return prefs.object(forKey: ZeatUserDefaults.phoneVerified) as? String ?? ""
    }
    
    static func setPhoneVerified (phoneVerified: String) -> Void {
        prefs.setValue(email, forKeyPath: ZeatUserDefaults.phoneVerified)
    }
    
    static func getNickName () -> String {
        return prefs.object(forKey: ZeatUserDefaults.nickName) as? String ?? ""
    }
    
    static func setNickName (nickName: String) -> Void {
        prefs.setValue(nickName, forKeyPath: ZeatUserDefaults.nickName)
    }
    
    static func getFCMTokenRegistrationStatus () -> Bool {
        return prefs.object(forKey: ZeatUserDefaults.FCMTokenRegistrationStatus) as? Bool ?? false
    }

    static func setFCMTokenRegistrationStatus (FCMTokenRegistrationStatus: Bool) -> Void {
        prefs.setValue(FCMTokenRegistrationStatus, forKeyPath: ZeatUserDefaults.FCMTokenRegistrationStatus)
    }

    static func setOrderDateTime (orderDateTime: Date?) -> Void {
        if let orderDateTime = orderDateTime {
            prefs.setValue(orderDateTime, forKey: ZeatUserDefaults.orderDateTime)
        }
    }
    static func getOrderDateTime () -> Date? {
        return prefs.object(forKey: ZeatUserDefaults.orderDateTime) as? Date
    }

    static func setOrderStatus (orderStatus: String?) -> Void {
        if let orderStatus = orderStatus {
            prefs.setValue(orderStatus, forKeyPath: ZeatUserDefaults.orderStatus)
        }
    }
    static func getOrderStatus () -> String? {
        return prefs.object(forKey: ZeatUserDefaults.orderStatus) as? String ?? ""
    }

    static func setLastFetchedDate (lastFetchedDate: Date?) -> Void {
        if let lastFetchedDate = lastFetchedDate {
            prefs.setValue(lastFetchedDate, forKey: ZeatUserDefaults.lastFetchedDate)
        }
    }
    static func getLastFetchedDate () -> Date? {
        return prefs.object(forKey: ZeatUserDefaults.lastFetchedDate) as? Date
    }

    
//    static func setOrder (order: Order?) -> Void {
//        if let order = order {
//
//            let encodedData = NSKeyedArchiver.archivedData(withRootObject: order)
//            prefs.setValue(encodedData, forKeyPath: ZeatUserDefaults.order)
//        } else {
//            prefs.setValue(nil, forKey: ZeatUserDefaults.order)
//        }
//    }

//    static func setOrder (order: Order?) -> Void {
//        if let order = order {
//            prefs.setValue(order, forKeyPath: ZeatUserDefaults.order)
//        } else {
//            prefs.setValue(nil, forKey: ZeatUserDefaults.order)
//        }
//    }
//
//
//    static func getOrder () -> Data? {
//        return prefs.object(forKey: ZeatUserDefaults.order) as? Data
//    }

}
