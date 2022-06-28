//
//  GiphyAPIRequest.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

protocol GiphyAPIRequest: APIRequest, GiphyAPIRequestSpec { }

protocol GiphyAPIRequestSpec {
    var serviceKey: String { get }
}

extension GiphyAPIRequestSpec {
    var baseURL: URL? {
        return URL(string: "https://api.giphy.com/v1")
    }

    var serviceKey: String {
        return "Zo01seUJhBkXATpgWm2lnL4m2b07xREM"
    }
}
