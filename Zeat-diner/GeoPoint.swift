//
//  GeoPoint.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 8/14/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation
import CoreLocation

class GeoPoint: Codable {
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    func location() -> CLLocation {
        return CLLocation.init(latitude: latitude!, longitude: longitude!)
    }

}
