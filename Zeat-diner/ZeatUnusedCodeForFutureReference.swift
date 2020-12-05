//
//  ZeatUnusedCodeForFutureReference.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 5/9/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit

class ZeatUnusedCodeForFutureReference {
    
    //        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    //        imageView.isUserInteractionEnabled = true
    //        imageView.addGestureRecognizer(tapGestureRecognizer)
    
    //        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RestaurantDineInController.closeRestaurant))
    //
    //        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(RestaurantDineInController.highlightCloseButton))
    //
    //        longPressGestureRecognizer.minimumPressDuration = 0.001
    //        closeButtonImage.addGestureRecognizer(tapGestureRecognizer)
    //        closeButtonImage.addGestureRecognizer(longPressGestureRecognizer)
    //
    //        closeButtonImage.image = #imageLiteral(resourceName: "CloseWhiteInactive")
    //        closeButtonImage.highlightedImage = #imageLiteral(resourceName: "CloseWhiteActive")
    //        closeButtonImage.isUserInteractionEnabled = true


    //    func closeRestaurant()
    //    {
    //        closeButtonImage.isHighlighted = true
    //        dismiss?()
    //    }
    //
    //    func highlightCloseButton(longPressGestureRecognizer: UILongPressGestureRecognizer)
    //    {
    //        switch (longPressGestureRecognizer.state) {
    //        case .began:
    //            closeButtonImage.isHighlighted = true
    //        case .ended:
    //            closeButtonImage.isHighlighted = false
    //            let view = longPressGestureRecognizer.view
    //            let location = longPressGestureRecognizer.location(in: view)
    //            let touchInside = view?.bounds.contains(location)
    //            if touchInside! {
    //                dismiss?()
    //            }
    //        case .cancelled:
    //            closeButtonImage.isHighlighted = false
    //        default: break
    //        }
    //    }


    
    //
    //    static func JSONDecoder() -> JSONDecoder {
    //        let decoder = JSONDecoder()
    //        if #available(iOS 10.0, *) {
    //            decoder.dateDecodingStrategy = .iso8601
    //        } else {
    //            // Fallback on earlier versions
    //            let dateFormatter = DateFormatter()
    //            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    //            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    //            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    //            decoder.dateDecodingStrategy = .formatted(dateFormatter)
    //        }
    //        return decoder
    //    }
    
    
    //    static formatforRestaurant
    
    //    static func checkDinerStatus(forceCheck: Bool) {
    //
    //        var checkForStatus: Bool = true
    //        let validDiningStatus = ["waiting_for_table", "table_assigned", "check_requested", "payment_initiated", "payment_completed"]
    //
    ////        if let order = ZeatUserDefaults.getOrder() {
    ////            if order.orderDate >= Date ().addingTimeInterval(-2*60*60) &&
    ////                validDiningStatus.contains(order.status){
    ////                return order
    ////            }
    ////        }
    //
    //        if let lastFetchedDate = ZeatUserDefaults.getLastFetchedDate() {
    //            if lastFetchedDate > Date ().addingTimeInterval(-1*60) {
    //                return
    //            }
    //        }
    //
    //
    //
    //
    //
    //
    //        if forceCheck {
    //            // Don't check for status if it was last obtained within one minute
    //            //
    //            if let lastFetchedDate = ZeatUserDefaults.getLastFetchedDate() {
    //                if lastFetchedDate > Date ().addingTimeInterval(-1*60) {
    //                    checkForStatus = false
    //                }
    //            }
    //        } else {
    //            guard let order = ZeatUserDefaults.getOrder() else {
    //                return
    //            }
    //
    ////            guard let orderDateTime = ZeatUserDefaults.getOrderDateTime()
    ////                ,let orderStatus = ZeatUserDefaults.getOrderStatus() else {
    ////                    return
    ////            }
    //
    //            if order.orderDate >= Date ().addingTimeInterval(-2*60*60) &&
    //                validDiningStatus.contains(order.status) {
    //                checkForStatus = false
    //            } else {
    //                ZeatUserDefaults.setOrder(order: nil)
    ////                ZeatUserDefaults.setOrderDateTime(orderDateTime: nil)
    ////                ZeatUserDefaults.setOrderStatus(orderStatus: nil)
    //            }
    //        }
    //
    //        if checkForStatus {
    //            DinerService.dinerStatus(completionHandler: {result in
    //
    //                switch result {
    //                case .success(let order):
    //                    if let order = order {
    //                        ZeatUserDefaults.setOrderDateTime(orderDateTime: order.orderDate)
    //                        ZeatUserDefaults.setOrderStatus(orderStatus: order.status)
    //                        ZeatUserDefaults.setOrder(order: order)
    //                    }
    //                    ZeatUserDefaults.setLastFetchedDate(lastFetchedDate: Date())
    //
    //                case .failure(_): break
    //                }
    //
    //            })
    //
    //        }
    //    }

    
}
