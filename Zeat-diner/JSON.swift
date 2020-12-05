////
////  JSON.swift
////  Zeat-diner
////
////  Created by Kumaresan Sankaranarayanan on 11/19/16.
////  Copyright © 2016 Zeat. All rights reserved.
////
//
//import Foundation
//import SwiftyJSON
//
//extension JSON {
//    
//    
//    public var date: Date? {
//        get {
//            if let str = self.string {
//                return JSON.jsonDateFormatter.date(from: str)
//            }
//            return nil
//        }
//    }
//    
//    private static let jsonDateFormatter: DateFormatter = {
//        let fmt = DateFormatter()
//        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        fmt.timeZone = TimeZone.init(secondsFromGMT: 0)
//        return fmt
//    }()
//}

