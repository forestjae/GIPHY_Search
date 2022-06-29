//
//  GifDTO+Mapping.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

extension GifSearchResponse {
    func toGifs() -> [Gif] {
        return self.results.compactMap { $0.toGif() }
    }
}

extension GifResponse {
    func toGif() -> Gif {
        return Gif(
            identifier: self.identifer,
            title: self.title,
            user: self.user?.toUser(),
            imageSet: self.images.toImageSet()
        )
    }
}

extension UserResponse {
    func toUser() -> User {
        return User(
            name: self.username,
            displayedName: self.displayName,
            description: self.userDescription,
            avatarImageURL: self.avatarURL
        )
    }
}

extension ImageSetResponse {
    func toImageSet() -> ImageSet {
        let originalWidth = Double(self.original.width) ?? 100
        let originalHeight = Double(self.original.height) ?? 100
        return ImageSet(
            imageURL: self.original.url,
            originalWidth: originalWidth,
            originalHeight: originalHeight,
            originalMP4Image: self.original.mp4,
            gridImageURL: self.fixedWidth.url,
            gridMp4URL: self.fixedWidth.mp4
        )
    }
}
