//
//  SearchQuery+CoreDataProperties.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/30.
//
//

import Foundation
import CoreData


extension SearchQuery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchQuery> {
        return NSFetchRequest<SearchQuery>(entityName: "SearchQuery")
    }


}

extension SearchQuery : Identifiable {

}
