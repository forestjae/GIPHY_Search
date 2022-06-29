//
//  ImageItemViewModel.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

struct ImageItemViewModel: Hashable {
    var image: Gif
    var aspectRatio: Double
}

extension ImageItemViewModel {
    init(image: Gif) {
        self.image = image
        self.aspectRatio = image.imageSet.originalHeight / image.imageSet.originalWidth
    }
}
