//
//  DiningTable.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 3/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import Foundation

public enum contentTypeValues {
    case item
    case section
}


class Menu: Codable {
    
    var menuName: String?
    var menuDescription: String?
    var duration: [MenuDuration]?
    var active: Bool?
    var sections: [MenuSection]?
    var id: String?

    enum CodingKeys: String, CodingKey {
        case menuName = "name"
        case menuDescription = "description"
        case duration
        case active
        case sections
        case id
    }

    
    var totalItemsAndSections: Int = 0
    var sectionIndexArray: [String] = []
    var sectionOldArray: [Int] = []
    var subsectionIndexArray: [Int] = []
    var contentType = [Int: contentTypeValues]()
    var sectionArray = [Int: Int]()
    var subsectionArray =  [Int: Int]()
    var itemArray = [Int: Int]()
    
//    override init() {}
//
//    init(menuName: String?, menuDescription: String?, durationName: String?, durationStartTime: Date?, durationEndTime: Date?, active: Bool?) {
//        self.menuName = menuName
//        self.menuDescription = menuDescription
//        self.durationName = durationName
//        self.durationStartTime = durationStartTime
//        self.durationEndTime = durationEndTime
//        self.active = active
//
//    }
//
//    func encode(with aCoder: NSCoder) {
//
//        if menuName != nil {
//            aCoder.encode(menuName, forKey: "menuName")
//        }
//
//        if menuDescription != nil {
//            aCoder.encode(menuDescription, forKey: "menuDescription")
//        }
//
//        if durationName != nil {
//            aCoder.encode(durationName, forKey: "durationName")
//        }
//
//        if durationStartTime != nil {
//            aCoder.encode(durationStartTime, forKey: "durationStartTime")
//        }
//
//        if durationEndTime != nil {
//            aCoder.encode(durationEndTime, forKey: "durationEndTime")
//        }
//
//        if active != nil {
//            aCoder.encode(active, forKey: "active")
//        }
//
//        if menuSections.count > 0 {
//            aCoder.encode(menuSections, forKey: "menuSections")
//        }
//
//    }
//
//    required convenience init?(coder aDecoder: NSCoder) {
//
//        self.init()
//
//        menuName = aDecoder.decodeObject(forKey: "menuName") as? String
//        menuDescription = aDecoder.decodeObject(forKey: "menuDescription") as? String
//        durationName = aDecoder.decodeObject(forKey: "durationName") as? String
//        durationStartTime = aDecoder.decodeObject(forKey: "durationStartTime") as? Date
//        durationEndTime = aDecoder.decodeObject(forKey: "durationEndTime") as? Date
//
//        if aDecoder.containsValue(forKey: "active"){
//            active = aDecoder.decodeBool(forKey: "active")
//        }
//
//        if let menuSections = aDecoder.decodeObject(forKey: "menuSections") as? [MenuSection] {
//            self.menuSections = menuSections
//        }
//
//    }
    
    func calculateSections() -> Void {

        totalItemsAndSections = 0
        contentType = [:]

        for (sectionIndex, section) in (sections?.enumerated())! {
            for (subsectionIndex, subsection) in section.subsections.enumerated() {

                subsectionIndexArray.append(subsectionIndex)


                contentType[totalItemsAndSections] = contentTypeValues.section
                sectionArray[totalItemsAndSections] = sectionIndex
                subsectionArray[totalItemsAndSections] = subsectionIndex

                totalItemsAndSections += 1

                for(itemIndex, _) in subsection.items.enumerated() {
                    contentType[totalItemsAndSections] = contentTypeValues.item
                    sectionArray[totalItemsAndSections] = sectionIndex
                    subsectionArray[totalItemsAndSections] = subsectionIndex
                    itemArray[totalItemsAndSections] = itemIndex
                    totalItemsAndSections += 1
                }
            }
        }

    }

    func sectionItemCount(sectionIndex: Int, subsectionIndex: Int) -> Int {
        let section = self.sections![sectionIndex]
        let subsection = section.subsections[subsectionIndex]

        return subsection.items.count
    }
    
//    func getSections() -> [String] {
//        
//        var sectionArray: [String] = []
//        
//        for section in menuSections {
//            for subsection in section.subsections {
//                sectionArray.append(<#T##newElement: Element##Element#>)
//            }
//        }
//        return 0
//    }
    
}
