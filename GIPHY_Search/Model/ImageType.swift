//
//  ImageType.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/30.
//

import Foundation

enum ImageType: String, CaseIterable {
    case gif
    case sticker

    var description: String {
        switch self {
        case .gif:
            return "GIF"
        case .sticker:
            return "Sticker"
        }
    }
}

extension ImageType {
    init?(index: Int) {
        switch index {
        case 0:
            self = .gif
        case 1:
            self = .sticker
        default:
            return nil
        }
    }
}
