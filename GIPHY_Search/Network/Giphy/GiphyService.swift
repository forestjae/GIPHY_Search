//
//  GiphyAPIProvider.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

protocol GiphyService {
    func searchGif(
        type: ImageType,
        query: String,
        offset: Int,
        completion: @escaping ((Result<GifPage, APIError>) -> Void)
    ) -> Cancellable?
}
