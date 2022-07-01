//
//  GifSearchRequest.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

struct GifSearchRequest: GiphyAPIRequest {
    typealias APIResponse = GifSearchResponse

    let type: ImageType
    let method: HTTPMethod = .get
    var path: String {
        switch self.type {
        case .gif:
            return "gifs/search"
        case .sticker:
            return "stickers/search"
        }
    }

    let headers: [String : String]? = nil
    let query: String
    let imageSetConfiguration: String = "clips_grid_picker"
    let limit: Int = 10
    let offset: Int

    var parameters: [String : String] {
        [
            "api_key": self.serviceKey,
            "q": self.query,
            "bundle": self.imageSetConfiguration,
            "limit": String(self.limit),
            "offset": String(self.offset)
        ]
    }
}
