//
//  GifSearchRequest.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

struct GifSearchRequest: GiphyAPIRequest {
    typealias APIResponse = GifSearchResponse

    let method: HTTPMethod = .get
    let path: String = "gifs/search"
    let headers: [String : String]? = nil
    let query: String
    let imageSetConfiguration: String = "clips_grid_picker"

    var parameters: [String : String] {
        [
            "api_key": self.serviceKey,
            "q": self.query,
            "bundle": self.imageSetConfiguration
        ]
    }
}
