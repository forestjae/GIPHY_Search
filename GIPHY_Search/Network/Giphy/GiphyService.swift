//
//  GiphyAPIProvider.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

final class GiphyService {
    let apiProvider: APIProvider

    init(apiProvider: APIProvider) {
        self.apiProvider = apiProvider
    }

    func searchGif(
        type: ImageType,
        query: String,
        offset: Int,
        completion: @escaping ((Result<GifPage, APIError>) -> Void)
    ) -> Cancellable? {
        let request = GifSearchRequest(type: type, query: query, offset: offset)
        return self.apiProvider.request(request) { result in
            let convertedResult = result
                .map { $0.toGifPage() }
            completion(convertedResult)
        }
    }
}
