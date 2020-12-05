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

class OrderService {

    static func endPointForNewOrder() -> String {
        let urlString = ZeatServiceConstants.baseUrl + "orders"
        return urlString
    }

    static func endPointForActiveOrder() -> String {
        let urlString = ZeatServiceConstants.baseUrl + "orders/active"
        return urlString
    }

    static func endPointForOrderDetail(forOrder orderId: String) -> String {
        let urlString = ZeatServiceConstants.baseUrl + "orders/\(orderId)"
        return urlString
    }

    
    static func endPointForAddingItemToOrder(forOrder orderId: String) -> String {
        let urlString = ZeatServiceConstants.baseUrl + "orders/\(orderId)/items"
        return urlString
    }

    static func createNewOrder(forRequest order: Order, completionHandler: @escaping (Result<Order?>) -> Void) {
        
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

        
        let orderJson = try? encoder.encode(order)
        let orderJsonString = String.init(data: orderJson!, encoding: String.Encoding.utf8)
        print(orderJsonString!)
        
        ZeatSharedData.sharedInstance.restRequestHeaders() {result in
            switch result {
            case .success(let headers):
                Alamofire.request(OrderService.endPointForNewOrder() , method: .post, parameters: [:], encoding: JSONStringArrayEncoding(string: orderJsonString!), headers: headers)
                    .responseJSON { response in
                        let result = OrderService.processOrderReponse(response: response)
                        completionHandler(result)
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    static func getActiveOrder(completionHandler: @escaping (Result<Order?>) -> Void) {
        ZeatSharedData.sharedInstance.restRequestHeaders() {result in
            switch result {
            case .success(let headers):
                Alamofire.request(OrderService.endPointForActiveOrder() , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON { response in
                        let result = OrderService.processOrderReponse(response: response)
                        completionHandler(result)
                }

            case .failure(let error):
                completionHandler(.failure(error))

            }
        }
    }

    static func getOrderDetails(forOrder orderId: String, completionHandler: @escaping (Result<Order?>) -> Void) {
        ZeatSharedData.sharedInstance.restRequestHeaders() {result in
            switch result {
            case .success(let headers):
                Alamofire.request(OrderService.endPointForOrderDetail(forOrder: orderId) , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON { response in
                        let result = OrderService.processOrderReponse(response: response)
                        completionHandler(result)
                }
                
            case .failure(let error):
                completionHandler(.failure(error))
                
            }
        }
    }
    
    static func joinDiningTable(forRestaurant zeatId: String, forOrder orderId: String, preApprovedby approverId: Int?, completionHandler: @escaping (Result<Order?>) -> Void) {
        
        var parameters: Parameters?
        
        if let approverId = approverId {
            parameters = ["approver_diner_id": approverId]
        }

        Alamofire.request(ZeatServiceConstants.joinTable(atRestaurant: zeatId, forOrder: orderId), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ZeatServiceConstants.restRequestHeaders())
            .responseJSON { response in
                let result = OrderService.processOrderReponse(response: response)
                completionHandler(result)
        }
    }
    
    static func listDiningTable(forRestaurant zeatId: String, completionHandler: @escaping (Result<[Order]>) -> Void) {
        ZeatSharedData.sharedInstance.restRequestHeaders() {result in
            switch result {
            case .success(let headers):
                Alamofire.request(RestaurantService.endPointForListingDiningTables(restaurantIdentifier: zeatId), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON { response in
                        let result = OrderService.processOrderArrayReponse(response: response)
                        completionHandler(result)
                }

            case .failure(let error):
                completionHandler(.failure(error))
                
            }
        }
    }
    
    static func addItemTo(order orderId: String, forItems orderItems: [OrderItem], completionHandler: @escaping (Result<String>) -> Void) {
        
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
        
        
        let orderItemsJson = try? encoder.encode(orderItems)
        let orderItemsJsonString = String.init(data: orderItemsJson!, encoding: String.Encoding.utf8)
        print(orderItemsJsonString!)
        
        ZeatSharedData.sharedInstance.restRequestHeaders() {result in
            switch result {
            case .success(let headers):
                Alamofire.request(OrderService.endPointForAddingItemToOrder(forOrder: orderId) , method: .post, parameters: [:], encoding: JSONStringArrayEncoding(string: orderItemsJsonString!), headers: headers)
                    .responseJSON { response in
                        let result = OrderService.processAddToOrderResponse(response: response)
                        completionHandler(result)
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    
    private static func processOrderArrayReponse(response: DataResponse<Any>) -> Result<[Order]> {
        switch response.result {
        case .success(let responseData):

            guard let status = (responseData as AnyObject).value(forKeyPath: "status") as? String
                else {
                    let errorResponse = ZeatError.init(errorTitle: "Fetch Error", errorMessage: "Unable to fetch orders")
                    return .failure(errorResponse)
            }

            var orderArray = [Order]()

            if status == "SUCCESS" {
               let nestedJson = (responseData as AnyObject).value(forKeyPath: "order")
                do {
                    let decoder = JSONDecoder()
                    if #available(iOS 10.0, *) {
                        decoder.dateDecodingStrategy = .iso8601
                    } else {
                        // Fallback on earlier versions
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    }

                    let data = try JSONSerialization.data(withJSONObject: nestedJson as Any)
                    orderArray = try decoder.decode([Order].self, from: data)
                } catch {
                    print(error)
                }
            }
            
            return .success(orderArray)

        case .failure( _):
            var error: ZeatError?
            error = ZeatError.init(errorTitle: "General Error" , errorMessage: "Error while getting active Order list.")
            return .failure(error!)
        }
    }
    
    
    private static func processOrderReponse(response: DataResponse<Any>) -> Result<Order?> {
        switch response.result {
        case .success(let responseData):
            guard let status = (responseData as AnyObject).value(forKeyPath: "status") as? String
                else {
                    let errorResponse = ZeatError.init(errorTitle: "Fetch Error", errorMessage: "Unable to fetch active order")
                    return .failure(errorResponse)
            }
            
            if status == "SUCCESS" {
                let orderJson = (responseData as AnyObject).value(forKeyPath: "order")
                do {
                    let decoder = JSONDecoder()
                    if #available(iOS 10.0, *) {
                        decoder.dateDecodingStrategy = .iso8601
                    } else {
                        // Fallback on earlier versions
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    }
                    
                    let orderData = try JSONSerialization.data(withJSONObject: orderJson as Any)
                    let order = try decoder.decode(Order.self, from: orderData)
                    
                    if (order.orderId == nil) {
                        return .success(nil)
                    } else {
                        return .success(order)
                    }
                } catch {
                    print(error)
                    let errorResponse = ZeatError.init(errorTitle: "Fetch Error", errorMessage: "Unable to fetch active order")
                    return .failure(errorResponse)
                }
            } else if status == "ERROR" {
                let errorResponse = ZeatError.init(errorTitle: "Fetch Error", errorMessage: "Unable to fetch active order")
                return .failure(errorResponse)

            } else {
                return .success(nil)
            }
        case .failure( _):
            var error: ZeatError?
            error = ZeatError.init(errorTitle: "General Error" , errorMessage: "Error while getting active order.")
            print (response.result)
            return .failure(error!)
        }
    }

    private static func processAddToOrderResponse(response: DataResponse<Any>) -> Result<String> {
        switch response.result {
        case .success(let responseData):
            
            guard let status = (responseData as AnyObject).value(forKeyPath: "status") as? String
                else {
                    let errorResponse = ZeatError.init(errorTitle: "Fetch Error", errorMessage: "Unable to fetch orders")
                    return .failure(errorResponse)
            }
            
            if status == "SUCCESS" {
                return .success(status)
            } else {
                var error: ZeatError?
                error = ZeatError.init(errorTitle: "General Error" , errorMessage: "Error while adding items to Order.")
                return .failure(error!)
            }
            
        case .failure( _):
            var error: ZeatError?
            error = ZeatError.init(errorTitle: "General Error" , errorMessage: "Error while adding items to Order.")
            return .failure(error!)
        }
    }

    
    
}
