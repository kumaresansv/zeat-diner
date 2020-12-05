//
//  Restaurant.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 12/15/16.
//  Copyright © 2016 Zeat. All rights reserved.
//

import Foundation
import CoreLocation

class Restaurant: Codable {
    var restaurantId: String?
    var name: String?
    var phone: String?
    var cuisine: [String]?
    var address: String?
    var distance: Double?
    var image: String?
    var geoPoint: GeoPoint?
    var menus: [ShortMenu]?

    func location() -> CLLocation? {
        guard let locationPoint = geoPoint else {
            return nil
        }

        return CLLocation.init(latitude: locationPoint.latitude!, longitude: locationPoint.longitude!)
    }

}
