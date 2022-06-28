//
//  APIService.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

protocol APIService {
    var session: URLSession { get }

    func request<T: APIRequest>(
        _ request: T,
        completion: @escaping (Result<T.APIResponse, APIError>) -> Void
    ) -> Cancellable?
}
