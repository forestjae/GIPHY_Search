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
}

extension Gif: Hashable {
    static func == (lhs: Gif, rhs: Gif) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
