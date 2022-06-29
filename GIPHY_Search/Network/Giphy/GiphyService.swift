//
//  GiphyAPIProvider.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

final class GiphyService {
    let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func searchGif(
        query: String,
        completion: @escaping ((Result<[Gif], APIError>) -> Void)
    ) -> Cancellable? {
        let request = GifSearchRequest(query: query)
        return self.apiService.request(request) { result in
            let convertedResult = result
                .map { $0.toGifs() }
            completion(convertedResult)
        }
    }
}
