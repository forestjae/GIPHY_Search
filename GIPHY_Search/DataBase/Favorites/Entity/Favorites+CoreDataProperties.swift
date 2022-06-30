//
//  Favorites+CoreDataProperties.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/30.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var identifier: String?

}

extension Favorites : Identifiable {

}
