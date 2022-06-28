//
//  GifSearchResponse.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

struct GifSearchResponse: Decodable {
    let results: [GifResponse]
    let pagination: Pagination

    enum CodingKeys: String, CodingKey {
        case results = "data"
        case pagination
    }
}

struct GifResponse: Decodable {
    let identifer: String
    let username: String
    let title: String
    let images: ImageSetResponse
    let user: UserResponse?

    enum CodingKeys: String, CodingKey {
        case identifer = "id"
        case username
        case title
        case images
        case user
    }
}

struct Pagination: Decodable {
    let totalCount: Int
    let count: Int
    let offset: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count
        case offset
    }
}

struct UserResponse: Decodable {
    let avatarURL: String
    let bannerImage: String
    let bannerURL: String
    let profileURL: String
    let username: String
    let displayName: String
    let userDescription: String
    let instagramURL: String
    let websiteURL: String
    let isVerified: Bool

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case bannerImage = "banner_image"
        case bannerURL = "banner_url"
        case profileURL = "profile_url"
        case username
        case displayName = "display_name"
        case userDescription = "description"
        case instagramURL = "instagram_url"
        case websiteURL = "website_url"
        case isVerified = "is_verified"
    }
}

struct ImageSetResponse: Decodable {
    let original: OriginalImageResponse
    let fixedWidth: FixedWidthImageResponse

    enum CodingKeys: String, CodingKey {
        case original
        case fixedWidth = "fixed_width"
    }
}

struct OriginalImageResponse: Decodable {
    let height: String
    let width: String
    let size: String
    let url: String
    let mp4Size: String
    let mp4: String
    let webpSize: String
    let webp: String
    let frames: String

    enum CodingKeys: String, CodingKey {
        case height
        case width
        case size
        case url
        case mp4Size = "mp4_size"
        case mp4
        case webpSize = "webp_size"
        case webp
        case frames
    }
}

struct FixedWidthImageResponse: Decodable {
    let height: String
    let width: String
    let size: String
    let url: String
    let mp4Size: String
    let mp4: String
    let webpSize: String
    let webp: String

    enum CodingKeys: String, CodingKey {
        case height
        case width
        case size
        case url
        case mp4Size = "mp4_size"
        case mp4
        case webpSize = "webp_size"
        case webp
    }
}
