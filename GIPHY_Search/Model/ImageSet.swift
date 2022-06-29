//
//  ImageSet.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

struct ImageSet {
    let imageURL: String
    let originalWidth: Double
    let originalHeight: Double
    let originalMP4Image: String
    let gridImageURL: String
    let gridMp4URL: String
}

extension ImageSet: Hashable { }
