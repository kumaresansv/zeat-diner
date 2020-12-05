//
//  ZeatActivityIndicator.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/26/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

//import NVActivityIndicatorViewExtended
import AWSCognitoIdentityProvider

class ZeatUtility {

    static let validDiningStatus = ["WaitingForTable", "TableAssigned", "CheckRequested", "PaymentInitiated", "PaymentCompleted"]

    static let validActiveDiningStatus = ["WaitingForTable", "TableAssigned", "CheckRequested", "PaymentInitiated"]
    
    static func setupActivityIndicator() -> Void {
        NVActivityIndicatorView.DEFAULT_TYPE = .pacman
        NVActivityIndicatorView.DEFAULT_COLOR = UIColor.black
        NVActivityIndicatorView.DEFAULT_TEXT_COLOR = UIColor.black
        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 15)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: CGFloat(30), height: CGFloat(30))
        NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 500
        NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 100
        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = ""
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor.init(white: 0.6, alpha: 0.60)
    }
    
    static func setBlockerTimeThreshold(timeInMilliSeconds: Int) {
        NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = timeInMilliSeconds
    }
    
    static func showActivityIndicator(withMessage message: String?) {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        
        if let message = message {
            NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
        }
    }
    
    static func stopActivityIndicator() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }

    static func ISOStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: date).appending("Z")
    }

    static func localTime(datetime: Date) -> String {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "hh24:mm"
        myFormatter.timeZone = TimeZone.current
        myFormatter.timeStyle = .short
        myFormatter.dateStyle = .none
        return myFormatter.string(from: datetime)
    }

    static func getRestaurantDetailsForActiveOrder(completionHandler: @escaping (Restaurant?) -> Void) {
        
        let activeOrder = ZeatSharedData.sharedInstance.activeOrder
        
        if let activeOrderRestaurant = ZeatSharedData.sharedInstance.orderRestaurant {
            if activeOrder?.restaurant?.restaurantId == activeOrderRestaurant.restaurantId {
                completionHandler(activeOrderRestaurant)
                return
            }
        }
        
        RestaurantService.getRestaurantDetails(restaurantIdentifier: (activeOrder?.restaurant?.restaurantId)!) { (result) in
            switch result {
            case .success(let restaurant):
                if let restaurant = restaurant {
                    ZeatSharedData.sharedInstance.orderRestaurant = restaurant
                }
                
                completionHandler(restaurant)
                return
                
            case .failure(_):
                ZeatSharedData.sharedInstance.orderRestaurant = nil
                completionHandler(nil)
                return
            }
        }
    }
    
    static func getDinerActiveOrder(completionHandler: @escaping (Order?) -> Void) {
        
        if let activeOrder = ZeatSharedData.sharedInstance.activeOrder {
            if activeOrder.orderDate! >= Date ().addingTimeInterval(-4*60*60) &&
                ZeatUtility.validActiveDiningStatus.contains(activeOrder.orderStatus!){
                completionHandler(activeOrder)
                return
            } else {
                ZeatSharedData.sharedInstance.activeOrder = nil
            }
        }
        
        // Do not fetch order again if fetched 5 minuts ago
        if let lastFetchedDate = ZeatSharedData.sharedInstance.lastTimeWhenOrderFetched {
            if lastFetchedDate > Date ().addingTimeInterval(-1*1*60) {
                completionHandler(nil)
                return
            }
        }
        
        // Call Service to get Order Details for future use
        OrderService.getActiveOrder() {result in

            switch result {
            case .success(let order):
                if let order = order {
                    ZeatSharedData.sharedInstance.activeOrder = order
                }

                ZeatSharedData.sharedInstance.lastTimeWhenOrderFetched = Date ()
                completionHandler(order)
                return

            case .failure(_):
                ZeatSharedData.sharedInstance.activeOrder = nil
                completionHandler(nil)
                return
            }
        }
    }
    
    static func getDinerActiveOrder() -> Order? {

        if let activeOrder = ZeatSharedData.sharedInstance.activeOrder {
            if ZeatUtility.validActiveDiningStatus.contains(activeOrder.orderStatus!){
                return activeOrder
            } else {
                ZeatSharedData.sharedInstance.activeOrder = nil
            }
        }
        
        return nil

    }
    
    static func getOrderDetails(completionHandler: @escaping (Order?) -> Void) {
        
        guard let activeOrder = ZeatSharedData.sharedInstance.activeOrder
            else {
            completionHandler(nil)
            return
        }
        
        OrderService.getOrderDetails(forOrder: activeOrder.orderId!) {result in
            
            switch result {
            case .success(let order):
                if let order = order {
                    ZeatSharedData.sharedInstance.activeOrder = order
                }
                
                ZeatSharedData.sharedInstance.lastTimeWhenOrderFetched = Date ()
                completionHandler(order)
                return
                
            case .failure(_):
                ZeatSharedData.sharedInstance.activeOrder = nil
                completionHandler(nil)
                return
            }
        }
    }

    
    

}
