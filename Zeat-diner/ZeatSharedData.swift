//
//  ZeatSharedInstance.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 5/9/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider
import Alamofire
import AWSSNS

public final class ZeatSharedData {

    public static let sharedInstance = ZeatSharedData.init()
    private let apiKey = "FKYjczrHBb3AR7SzUeFMh75F5ai0EXSj55Ljv3Jw"
    private let SNSPlatformApplicationArn = "arn:aws:sns:us-west-2:367786383475:app/APNS_SANDBOX/ZeatMobileDevelopment"

    private var order: Order?
//    private var restaurant: Restaurant?
    var orderRestaurant: Restaurant?

    private var menuList: [Menu]?

    var cart: Cart?
    
    var user: AWSCognitoIdentityUser?

    var displayedRestaurantId: String?
    var lastTimeWhenOrderFetched: Date?

    private init() {
    }
    
    func initializeSharedInstance() {
        self.order = ZeatUtility.getDinerActiveOrder()
        self.lastTimeWhenOrderFetched = Date()
    }
    
    
//    func initializeFromUserDefaults() {
//        if let orderJson = ZeatUserDefaults.getOrder() {
//            do {
//                let decoder = JSONDecoder()
//                if #available(iOS 10.0, *) {
//                    decoder.dateDecodingStrategy = .iso8601
//                } else {
//                    // Fallback on earlier versions
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
//                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
//                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
//                }
//
//                self.order = try decoder.decode(Order.self, from: orderJson)
//
//            }
//            catch {
//                print(error)
//            }
//        }
//
//    }
    
    func saveToUserDefaults() {

        let encoder = JSONEncoder()
        
        if #available(iOS 10.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        } else {
            // Fallback on earlier versions
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
        }
    }
    
//    func getIdToken() -> String? {
//        var requestToken = false
//        var returnToken = false
//
//        if let expirationTime = ZeatUserDefaults.getExpirationTime() {
//            let currentDate = Date()
//            if expirationTime > currentDate {
//                returnToken = true
//                if expirationTime < currentDate.addingTimeInterval(5*60) {
//                    requestToken = true
//                }
//            } else {
//                requestToken = true
//            }
//        } else {
//            requestToken = true
//        }
//
//        // Request Token because it is either expired or going to expire
//        if (requestToken) {
//            ZeatSharedData.sharedInstance.getSessionToken() { _ in
//            }
//        }
//
//        // Return Token If It is Valid
//        if (returnToken) {
//            return ZeatUserDefaults.getIdToken()
//        } else {
//            return ""
//        }
//    }

    func restRequestHeaders(completionHandler: @escaping (Result<HTTPHeaders>) -> Void) {
        
        ZeatSharedData.sharedInstance.getSessionToken() { status in
            if (status) {
                var header = [
                    "Content-Type": "application/json",
                    "x-api-key": self.apiKey
                ]
                
                // Return Authorization Header with the Token
                if let idToken = ZeatUserDefaults.getIdToken() {
                    header[AWSAuthorization] = idToken
                }
                completionHandler(.success(header))
            } else {
                var error: ZeatError?
                error = ZeatError.init(errorTitle: "Login Required" , errorMessage: "Please login again")
                completionHandler(.failure(error!))
            }
        }
    }

    func restRequestApiHeader() -> HTTPHeaders {
        
        let header = [
            "Content-Type": "application/json",
            "x-api-key": apiKey
        ]
        
        return header
    }
    
//    var currentMenu: [Menu]? {
//        get {
//            if orderRestaurantId != nil && self.displayedRestaurantId == self.orderRestaurantId {
//                return menuList
//            } else {
//                return nil
//            }
//        }
//        set {
//            if orderRestaurantId == nil || self.displayedRestaurantId == self.orderRestaurantId {
//                self.menuList = newValue
//            }
//        }
//    }
    
    var currentCart: Cart? {
        get {
            if self.cart == nil {
                self.cart = Cart(forRestaurant: (self.orderRestaurant?.restaurantId!)!)
            }
            return self.cart
        }
    }
    
    var activeOrder: Order? {
        get {
            return self.order
        }
        set {
            self.order = newValue
        }
    }
    
//    func getSNSPlatformEndPoint(apnsDeviceToken: String) {
//        // Check if SNS Endpoint Arn is Stored
//
//        if let snsEndPointArn = ZeatUserDefaults.getSNSEndpointArn() {
//            // Get Endpoint Attributes. If Exception found, create your Arn and store it
//
//
//        } else {
//            // Create SNS Endping Arn and Store It
//            createSNSEndPointArn(apnsDeviceToken: apnsDeviceToken)
//        }
//    }
//
    
    func createSNSEndPointArn(apnsDeviceToken: String) -> Void {
        
        let snsEndPointArn = ZeatUserDefaults.getSNSEndpointArn()
        
        let tokens = NSDictionary(dictionary: [ZeatCognitoIdp : ZeatUserDefaults.getIdToken()!])
        let cognitoProviderManager = ZeatAWSIdentityProviderManager(tokens: tokens)
        
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USWest2, identityPoolId: ZeatCognitoIdentityPoolId, identityProviderManager: cognitoProviderManager)
        
        let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        AWSSNS.register(with: configuration!, forKey: "dev-Diner-us-west-2")
        
        let sns = AWSSNS(forKey: "dev-Diner-us-west-2")
        
        let request = AWSSNSCreatePlatformEndpointInput()
        request?.token = apnsDeviceToken
        request?.platformApplicationArn = self.SNSPlatformApplicationArn


        
        ZeatSharedData.sharedInstance.getSessionToken() { status in
            if (status) {
                var task = AWSTask<AnyObject>.init(result: nil)
                
                if (snsEndPointArn == nil) {
                    task = task.continueOnSuccessWith(block: { (task: AWSTask!) -> Any? in
                        return sns.createPlatformEndpoint(request!).continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask!) -> Void in
                            if task.error != nil {
                                // TODO
                                // Write code to raise a SNS message for us to follow up as the user was not able to
                                // to register for notification
                                print("Error: \(String(describing: task.error))")
                            } else {
                                let createEndpointResponse = task.result
                                print("endpointArn: \(String(describing: createEndpointResponse?.endpointArn))")
                                ZeatUserDefaults.setSNSEndpointArn(snsEndpointArn: (createEndpointResponse?.endpointArn)!)
                            }
                        })
                    })
                }
                
                task.continueOnSuccessWith(block: { (task: AWSTask!) in
                    let getEndPointAttributes = AWSSNSGetEndpointAttributesInput()
                    getEndPointAttributes?.endpointArn = snsEndPointArn
                    return sns.getEndpointAttributes(getEndPointAttributes!)
                }).continueWith(block: { (task: AWSTask!) -> Any? in
                    if let error = task.error as NSError? {
                        if (error.domain == AWSSNSErrorDomain || error.code == AWSSNSErrorType.notFound.rawValue || error.code == AWSSNSErrorType.internalError.rawValue) {
                            return sns.createPlatformEndpoint(request!).continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask!) -> Any? in
                                if task.error != nil {
                                    // TODO
                                    // Write code to raise a SNS message for us to follow up as the user was not able to
                                    // to register for notification
                                    print("Error: \(String(describing: task.error))")
                                    return nil
                                } else {
                                    let createEndpointResponse = task.result
                                    print("endpointArn: \(String(describing: createEndpointResponse?.endpointArn))")
                                    ZeatUserDefaults.setSNSEndpointArn(snsEndpointArn: (createEndpointResponse?.endpointArn)!)
                                    return nil
                                }
                            })

                        }
                        
                        return nil
                    }
                    
                    
                    if (task.result != nil) {
                        let getEndpointAttributesResponse = task.result as? AWSSNSGetEndpointAttributesResponse
                        
                        if (getEndpointAttributesResponse?.attributes!["Token"] != apnsDeviceToken
                            || getEndpointAttributesResponse?.attributes!["Enabled"] == "false") {
                            var setAttributes = getEndpointAttributesResponse?.attributes
                            setAttributes!["Token"] = apnsDeviceToken
                            setAttributes!["Enabled"] = "true"
                            
                            let setEndPointAttributes = AWSSNSSetEndpointAttributesInput()
                            setEndPointAttributes?.endpointArn = snsEndPointArn
                            setEndPointAttributes?.attributes = setAttributes
                            return sns.setEndpointAttributes(setEndPointAttributes!)
                        }
                    }
                    
                    return nil
                }).continueWith(block: { (task: AWSTask!) -> Any? in
                    if (task.error != nil) {
                        print("Unable to register for remote notifications")
                    }
                    return nil
                })
            }
        }
    }
    
    func getSessionToken(completionHandler: @escaping (Bool) -> Void) {

        var requestToken = false
        var returnToken = false

        if let expirationTime = ZeatUserDefaults.getExpirationTime() {
            let currentDate = Date()
            if expirationTime > currentDate {
                returnToken = true
                if expirationTime < currentDate.addingTimeInterval(5*60) {
                    requestToken = true
                }
            } else {
                requestToken = true
            }
        } else {
            requestToken = true
        }
        
        if (requestToken) {

            // AWS Cognito Setup
            let pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSigninProviderKey)
            
            if let user = pool!.currentUser() {
                if user.isSignedIn {
                    user.getSession().continueWith {(task: AWSTask) -> Void in
                        if let error = task.error as NSError? {
                            print(error.userInfo["message"] as Any)
                            if(!returnToken) {
                                completionHandler(false)
                            }
                        } else if let result = task.result {
                            
                            if let accessToken = result.accessToken?.tokenString {
                                ZeatUserDefaults.setAccessToken(accessToken: accessToken)
                            }
                            
                            if let idToken = result.idToken?.tokenString {
                                ZeatUserDefaults.setIdToken(idToken: idToken)
                            }
                            
                            if let refreshToken = result.refreshToken?.tokenString {
                                ZeatUserDefaults.setRefreshToken(refreshToken: refreshToken)
                            }
                            
                            if let expirationTime = result.expirationTime {
                                print("*******EXPIRY TIME*********")
                                print(ZeatUtility.localTime(datetime: expirationTime))
                                ZeatUserDefaults.setExpirationTime(expirationTime: expirationTime)
                            }
                        }
                        
                        if(!returnToken) {
                            completionHandler(true)
                        }
                    }
                } else {
                    if(!returnToken) {
                        completionHandler(false)
                    }
                }
            } else {
                if(!returnToken) {
                    completionHandler(false)
                }
            }
        }
        
        // Return Immediately if there is a valid token that can be used.
        if (returnToken) {
            completionHandler(true)
        }
    }
    
    
    
    
}
