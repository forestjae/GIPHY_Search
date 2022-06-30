//
//  User.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

struct User {
    let name: String
    let displayedName: String
    let description: String
    let avatarImageURL: String
    let isVerified: Bool
}

extension User: Hashable { }
