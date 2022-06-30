//
//  CoreDataError.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/30.
//

import Foundation

enum DataSourceError: Error {
    case decodingFailure
    case jsonNotFound
    case coreDataSaveFailure(NSError)
}
