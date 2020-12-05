//
//  Restaurant+Rest.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 12/15/16.
//  Copyright © 2016 Zeat. All rights reserved.
//

import Foundation
import Alamofire
//import SwiftyJSON
import CoreLocation

class RestaurantService {

    static func endPointForListingDiningTables(restaurantIdentifier restaurantId: String) -> String {
        let urlString = ZeatServiceConstants.baseUrl + "restaurants/" + "\(restaurantId)" + "/list_tables"
        return urlString
    }

    static func endPointForListingOrders(restaurantIdentifier restaurantId: String) -> String {
        let urlString = ZeatServiceConstants.baseUrl + "restaurants/" + "\(restaurantId)" + "/orders"
        return urlString
    }

    
    static func search(searchlocation: CLLocation, currentLocation: CLLocation, completionHandler: @escaping (Result<[Restaurant]>) -> Void) {
        
        let hardCoded = CLLocation.init(latitude: 47.673988, longitude: -122.121513)
        
        Alamofire.request(ZeatServiceConstants.searchRestaurants(location: hardCoded) , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ZeatServiceConstants.restRequestHeaders()).responseJSON { response in
            let result = RestaurantService.processSearchResponse(response: response, location: currentLocation)
            completionHandler(result)
        }
    }

    static func getRestaurantDetails(restaurantIdentifier restaurantId: String, completionHandler: @escaping (Result<Restaurant?>)  -> Void) {
        
        Alamofire.request(ZeatServiceConstants.endPointForRestaurantDetail(restaurantIdentifier: restaurantId) , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ZeatServiceConstants.restRequestHeaders()).responseJSON { response in
            let result = RestaurantService.processRestaurantResponse(response: response)
            completionHandler(result)
        }
    }

    
    private static func processSearchResponse(response: DataResponse<Any>, location: CLLocation) -> Result<[Restaurant]> {
        switch response.result {
        case .success(let responseData):

            guard let status = (responseData as AnyObject).value(forKeyPath: "status") as? String
                else {
                    let errorResponse = ZeatError.init(errorTitle: "Fetch Error", errorMessage: "Unable to get nearby Restaurants")
                    return .failure(errorResponse)
            }
            

            if status == "SUCCESS" {
                
                if let nestedJson = (responseData as AnyObject).value(forKeyPath: "restaurants") {
                    var restaurantArray = [Restaurant]()

                    do {
                        let data = try JSONSerialization.data(withJSONObject: nestedJson)
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
                        restaurantArray = try decoder.decode([Restaurant].self, from: data)
                    } catch {
                        print(error)
                        let errorResponse = ZeatError.init(errorTitle: "Fetch Error", errorMessage: "Unable to get nearby Restaurants")
                        return .failure(errorResponse)
                    }

                    for restaurant in restaurantArray {
                        restaurant.image = ZeatServiceConstants.baseFileUrl + restaurant.restaurantId! + "/RestaurantImage.jpeg"
                        
                        var distanceInMeters: Double
                        if let restaurantLocation = restaurant.location() {
                            distanceInMeters = restaurantLocation.distance(from: location)
                        } else {
                            distanceInMeters = 0.0
                        }
                        restaurant.distance = distanceInMeters/MetersToMilesConversion
                    }
                    return .success(restaurantArray.sorted(by: {($0.distance)! < ($1.distance)!}))

                    
                } else {
                    let errorResponse = ZeatError.init(errorTitle: "Fetch Error", errorMessage: "Unable to get nearby Restaurants")
                    return .failure(errorResponse)
                }
            } else {
                let errorResponse = ZeatError.init(errorTitle: "Fetch Error", errorMessage: "Unable to get nearby Restaurants")
                return .failure(errorResponse)
            }
            
        case .failure(let error):
            return .failure(error)
        }
    }

    private static func processRestaurantResponse(response: DataResponse<Any>) -> Result<Restaurant?> {
        switch response.result {
        case .success(let responseData):

            guard let status = (responseData as AnyObject).value(forKeyPath: "status") as? String
                else {
                    let errorResponse = ZeatError.init(errorTitle: "Fetch Error", errorMessage: "Unable to get Restaurant details")
                    return .failure(errorResponse)
            }


            if status == "SUCCESS" {
                
                if let nestedJson = (responseData as AnyObject).value(forKeyPath: "restaurant") {
                    do {
                        var restaurant: Restaurant?
                        let data = try JSONSerialization.data(withJSONObject: nestedJson)
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
                        restaurant = try decoder.decode(Restaurant.self, from: data)
                        
                        restaurant?.image = ZeatServiceConstants.baseFileUrl + (restaurant?.restaurantId)! + "/RestaurantImage.jpeg"
                        return .success(restaurant!)

                    } catch {
                        print(error)
                        let errorResponse = ZeatError.init(errorTitle: "Fetch Error", errorMessage: "Unable to get Restaurant Details.")
                        return .failure(errorResponse)
                    }

                } else {
                    let errorResponse = ZeatError.init(errorTitle: "Fetch Error", errorMessage: "Unable to get Restaurant Details.")
                    return .failure(errorResponse)
                }
            } else {
                let errorResponse = ZeatError.init(errorTitle: "Fetch Error", errorMessage: "Unable to get Restaurant Details.")
                return .failure(errorResponse)
            }

        case .failure(let error):
            return .failure(error)
        }
    }
    
//    static func getMenu(forRestaurant zeatId: String, completionHandler: @escaping (Result<[Menu]>) -> Void) {
//
//        Alamofire.request(ZeatServiceConstants.getMenu(restaurantIdentifier: zeatId), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ZeatServiceConstants.restRequestHeaders())
//            .responseJSON { response in
//                let result = RestaurantService.processMenuResponse(response: response)
//                completionHandler(result)
//        }
//
//    }

    static func getMenuJson(menuUrl: String, completionHandler: @escaping (Result<Menu>) -> Void) {
        
        Alamofire.request(menuUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                let result = RestaurantService.processMenuResponseJson(response: response)
                completionHandler(result)
        }
        
    }

    
//    private static func processMenuResponse(response: DataResponse<Any>) -> Result<[Menu]> {
//        switch response.result {
//        case .success(let data):
//            let json = JSON(data)
//
//            var menuArray = [Menu]()
//
////            for (_, menuJson) in json["menus"] {
////                let menu = Menu.init(json: menuJson)
////                menu?.calculateSections()
////                menuArray.append(menu!)
////            }
//
//            return .success(menuArray)
//        case .failure(let error):
//            return .failure(error)
//        }
//    }

    private static func processMenuResponseJson(response: DataResponse<Any>) -> Result<Menu> {
        switch response.result {
        case .success(let responseData):
            do {
                let data = try JSONSerialization.data(withJSONObject: responseData)
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

                let menu = try decoder.decode(Menu.self, from: data)
                menu.calculateSections()
                return .success(menu)
            } catch {
                print(error)
                return .failure(error)
            }

        case .failure(let error):
            return .failure(error)
        }
    }

    static func listOrders(forRestaurant restaurantId: String, completionHandler: @escaping (Result<[Order]>) -> Void) {
        
        
        Alamofire.request(RestaurantService.endPointForListingOrders(restaurantIdentifier: restaurantId), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ZeatSharedData.sharedInstance.restRequestApiHeader())
            .responseJSON { response in
                let result = RestaurantService.processOrderArrayReponse(response: response)
                completionHandler(result)
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
            
            
            if status == "SUCCESS" {
                var orderArray = [Order]()
                guard let nestedJson = (responseData as AnyObject).value(forKeyPath: "orders")
                    else {
                        return .success(orderArray)
                }
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: nestedJson)
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
                    orderArray = try decoder.decode([Order].self, from: data)
                } catch {
                    print(error)
                }

                return .success(orderArray)
                
            } else {
                var error: ZeatError?
                error = ZeatError.init(errorTitle: "General Error" , errorMessage: "Error while getting open orders for Restaurant.")
                return .failure(error!)
            }
            
        case .failure( _):
            var error: ZeatError?
            error = ZeatError.init(errorTitle: "General Error" , errorMessage: "Error while getting open orders for Restaurant.")
            return .failure(error!)
        }
    }
    
}
