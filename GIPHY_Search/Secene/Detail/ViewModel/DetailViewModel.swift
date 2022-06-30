//
//  DetailViewModel.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

class DetailViewModel {
    weak var coordinator: DetailCoordinator?

    // MARK: - Output
    let animatedImageURL: String
    var userImage: ((Data) -> Void)?
    let userDisplayedName: String?
    let userName: String?
    let source: String?
    let isVerified: Bool?

    private let userImageURL: String?

    init(image: Gif) {
        self.animatedImageURL = image.imageSet.originalMP4Image
        self.userDisplayedName = image.user?.displayedName ?? image.user?.name
        self.userName = image.user?.name
        self.source = image.source
        self.isVerified = image.user?.isVerified
        self.userImageURL = image.user?.avatarImageURL
    }

    func loadUserImage() {
        guard let urlString = self.userImageURL,
              let url = URL(string: urlString)
        else {
            return
        }
        CacheManager.fetchImage(imageURL: url) { data in
            self.userImage?(data)
        }
    }
}
