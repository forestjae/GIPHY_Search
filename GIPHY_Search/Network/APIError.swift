//
//  APIError.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case serverError
    case invalidResponse
    case invalidData
    case parsingError
}
