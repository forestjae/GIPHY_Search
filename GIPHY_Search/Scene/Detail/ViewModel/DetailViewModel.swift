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
    let title: String
    var userImage: ((Data) -> Void)?
    let userDisplayedName: String?
    let userName: String?
    let source: String?
    let isVerified: Bool?
    let aspectRatio: Double
    var isFavorite: ((Bool) -> Void)?

    private let favoriteStorage: FavoriteStorage
    private let identifier: String
    private let userImageURL: String?

    init(image: Gif) {
        self.animatedImageURL = image.imageBundle.originalMp4Image
        self.title = image.type.description
        self.userDisplayedName = image.user?.displayedName ?? image.user?.name
        self.userName = image.user?.name
        self.source = image.source
        self.isVerified = image.user?.isVerified
        self.identifier = image.identifier
        self.userImageURL = image.user?.avatarImageURL
        self.aspectRatio = image.imageBundle.originalHeight / image.imageBundle.originalWidth
        self.favoriteStorage = FavoriteStorage()
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

    func favoriteStatus() {
        self.favoriteStorage.isFavorite(of: self.identifier) { result in
            switch result {
            case .success(let isFavorite):
                self.isFavorite?(isFavorite)
            case .failure(let error):
                print(error)
            }
        }
    }

    func setFavorite(_ completion: (Bool) -> Void) {
        do {
            try self.favoriteStorage.setFavorite(for: self.identifier)
            completion(true)
        } catch {
            completion(false)
        }
    }

    func setUnfavorite(_ completion: (Bool) -> Void) {
        do {
            try self.favoriteStorage.setUnfavorite(for: self.identifier)
            completion(false)
        } catch {
            completion(true)
        }
    }
}
