//
//  Diner+Rest.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 11/18/16.
//  Copyright © 2016 Zeat. All rights reserved.
//

import Foundation
import Alamofire
//import SwiftyJSON

class DinerService {
    
//    static func register(email: String, password: String, completionHandler: @escaping (Result<Diner>) -> Void) {
//        let parameters: Parameters = ["email": email, "password": password, "password_confirmation": password]
//
//        Alamofire.request(ZeatServiceConstants.dinerRegistration, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ZeatServiceConstants.restRequestHeaders())
//            .responseJSON { response in
//                let result = DinerService.validateLoginResponse(response: response)
//                completionHandler(result)
//        }
//    }
    
    
//    static func login(email: String, password: String, completionHandler: @escaping (Result<Diner>) -> Void) {
//        let parameters: Parameters = ["email": email, "password": password]
//
//        Alamofire.request(ZeatServiceConstants.dinerLogin, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ZeatServiceConstants.restRequestHeaders())
//            .responseJSON { response in
//                let result = DinerService.validateLoginResponse(response: response)
//                completionHandler(result)
//        }
//    }
    
//    static func dinerStatus(completionHandler: @escaping (Result<Order?>) -> Void) {
//        Alamofire.request(ZeatServiceConstants.dinerStatus, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ZeatServiceConstants.restRequestHeaders())
//            .responseJSON { response in
//                let result = DinerService.validateStatusReponse(response: response)
//                completionHandler(result)
//        }
//    }

    static func registerToken(token: DinerToken, completionHandler: @escaping (Result<String>) -> Void) {

        let encoder = JSONEncoder()
        let dinerTokenJson = try? encoder.encode(token)
        let dinerTokenJsonString = String.init(data: dinerTokenJson!, encoding: String.Encoding.utf8)
        print(dinerTokenJsonString!)

        Alamofire.request(ZeatServiceConstants.dinerTokenRegistration , method: .post, parameters: [:], encoding: JSONStringArrayEncoding(string: dinerTokenJsonString!), headers: ZeatServiceConstants.restRequestHeaders())
            .responseJSON { response in
                let result = DinerService.validateTokenResponse(response: response)
                completionHandler(result)
        }
    }

//    static func updateProfile(diner: Diner, completionHandler: @escaping (Result<Diner>) -> Void) {
//        Alamofire.request(ZeatServiceConstants.diner, method: .patch, parameters: diner.toUpdateProfileJSON(), encoding: JSONEncoding.default, headers: ZeatServiceConstants.restRequestHeaders())
//            .responseJSON { response in
//                let result = DinerService.validateUpdateResponse(response: response)
//                completionHandler(result)
//        }
//    }

    // Temporary logic for logout
    static func logout() -> Void {
        
        ZeatUserDefaults.setAccessToken(accessToken: "Logged Out")
        ZeatUserDefaults.setFCMTokenRegistrationStatus(FCMTokenRegistrationStatus: false)
        ZeatSharedData.sharedInstance.activeOrder = nil
        ZeatSharedData.sharedInstance.saveToUserDefaults()
//        ZeatUserDefaults.setOrder(order: nil)
    }
    
//    private static func validateLoginResponse(response: DataResponse<Any>) -> Result<Diner> {
//        switch response.result {
//        case .success(let data):
//            let json = JSON(data)
//            guard let headers = response.response?.allHeaderFields else {
//                return .failure(ZeatLoginError.systemError)
//            }
//
//            guard let accessToken = headers[ZeatUserDefaults.accessToken],
//                let email = headers[ZeatUserDefaults.email],
//                let client = headers[ZeatUserDefaults.client] else
//            {
//                // For now I am only getting the first value. From the UI, I was not able
//                // to reproduce a scenario where multiple errors were returned in the
//                // full_messages array
//                if let regError = json["errors"]["full_messages"][0].string {
//                    return .failure(ZeatLoginError.authError(reason: regError))
//                }
//
//                if let regError = json["errors"][0].string {
//                    return .failure(ZeatLoginError.authError(reason: regError))
//                }
//
//                return .failure(ZeatLoginError.authError(reason:
//                    "Unable to register now. Please try again."))
//
//            }
//
//            ZeatUserDefaults.setAccessToken(accessToken: accessToken as! String)
//            ZeatUserDefaults.setClient(client: client as! String)
//            ZeatUserDefaults.setEmail(email: email as! String)
//            ZeatUserDefaults.loggedIn()
//
//            if let nickName = json["data"]["nickname"].string {
//                ZeatUserDefaults.setNickName(nickName: nickName)
//            }
//
//            if let phone = json["data"]["phone"].string {
//                ZeatUserDefaults.setPhone(phone: phone)
//            }
//
//            if let phoneVerified = json["data"]["phone_verified"].string {
//                ZeatUserDefaults.setPhoneVerified(phoneVerified: phoneVerified)
//            }
//
//            guard let diner = Diner(json: json["data"]) else {
//                return .failure(ZeatLoginError.dinerSerialization(loginStatus: true))
//            }
//
//            return .success(diner)
//        case .failure(let error):
//            return .failure(error)
//        }
//    }
    
//    private static func validateUpdateResponse(response: DataResponse<Any>) -> Result<Diner> {
//        switch response.result {
//        case .success(let data):
//            let json = JSON(data)
//
//            if let nickName = json["diner"]["nickname"].string {
//                ZeatUserDefaults.setNickName(nickName: nickName)
//            }
//
//            if let phone = json["diner"]["phone"].string {
//                ZeatUserDefaults.setPhone(phone: phone)
//            }
//
//            if let phoneVerified = json["diner"]["phone_verified"].string {
//                ZeatUserDefaults.setPhoneVerified(phoneVerified: phoneVerified)
//            }
//
//            if let thumbImage = json["diner"]["profile_thumb_image_url"].string {
//                print(thumbImage)
//            }
//
//            guard let diner = Diner(json: json["diner"]) else {
//                return .failure(ZeatLoginError.dinerSerialization(loginStatus: true))
//            }
//
//            return .success(diner)
//        case .failure(let error):
//            return .failure(error)
//        }
//    }
    
    
    private static func validateTokenResponse(response: DataResponse<Any>) -> Result<String> {
        
        switch response.result {
        case .success:
            return .success(ZeatServiceConstants.ServiceStatusSuccess)
        case .failure(let error):
            print(error)
            return .failure(error)
        }
        
    }
    
//    private static func validateStatusReponse(response: DataResponse<Any>) -> Result<Order?> {
//        switch response.result {
//        case .success(let data):
//
//            let json = JSON(data)
//            var order: Order?
//
////            if let orderFromJson = Order.init(json: json["order"]) {
////                order = orderFromJson
////                return .success(order!)
////            } else {
////                return .success(order)
////            }
//            return .success(order)
//
//        case .failure( _):
//            var error: ZeatError?
//            error = ZeatError.init(errorTitle: "General Error" , errorMessage: "Error while requesting for table. Please try again later.")
//            error?.afterErrorAction = "STAY_ON_REQUEST_PAGE"
//            print (response.result)
//            return .failure(error!)
//        }
//    }
    
    
}
