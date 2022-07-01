//
//  GifDTO+Mapping.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

extension GifSearchResponse {
    func toGifPage() -> GifPage {
        let offset = self.pagination.offset
        let target = min(self.pagination.totalCount, 4999)
        let isNextPage = offset < target
        return GifPage(
            offset: offset,
            hasNextPage: isNextPage,
            gifs: self.results.compactMap { $0.toGif() }
        )
    }
}

extension GifResponse {
    func toGif() -> Gif? {
        guard let type = ImageType(rawValue: self.type) else {
            return nil
        }

        return Gif(
            identifier: self.identifier,
            title: self.title,
            user: self.user?.toUser(),
            imageBundle: self.images.toImageBundle(),
            source: self.source == "" ? nil : self.source,
            type: type
        )
    }
}

extension UserResponse {
    func toUser() -> User {
        return User(
            name: self.username,
            displayedName: self.displayName,
            description: self.userDescription,
            avatarImageURL: self.avatarURL,
            isVerified: self.isVerified
        )
    }
}

extension ImageSetResponse {
    func toImageBundle() -> ImageBundle {
        let originalWidth = Double(self.original.width) ?? 100
        let originalHeight = Double(self.original.height) ?? 100
        return ImageBundle(
            imageURL: self.original.url,
            originalWidth: originalWidth,
            originalHeight: originalHeight,
            originalMp4Image: self.original.mp4,
            gridImageURL: self.fixedWidth.url,
            gridMp4URL: self.fixedWidth.mp4
        )
    }
}
