//
//  Gif.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

struct Gif {
    let identifier: String
    let title: String
    let user: User?
    let imageSet: ImageSet
    let source: String?
    let type: ImageType
}

extension Gif: Hashable { }

struct GifPage {
    let offset: Int
    let hasNextPage: Bool
    let gifs: [Gif]
}
