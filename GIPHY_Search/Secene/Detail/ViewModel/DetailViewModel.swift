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
    var isFavorite: ((Bool) -> Void)?

    private let favoriteStorage: FavoriteStorage
    private let identifer: String
    private let userImageURL: String?

    init(image: Gif) {
        self.animatedImageURL = image.imageSet.originalMP4Image
        self.userDisplayedName = image.user?.displayedName ?? image.user?.name
        self.userName = image.user?.name
        self.source = image.source
        self.isVerified = image.user?.isVerified
        self.identifer = image.identifier
        self.userImageURL = image.user?.avatarImageURL
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
        self.favoriteStorage.isFavorite(of: self.identifer) { result in
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
            try self.favoriteStorage.setFavorite(for: self.identifer)
            completion(true)
        } catch {
            completion(false)
        }
    }

    func setUnfavorite(_ completion: (Bool) -> Void) {
        do {
            try self.favoriteStorage.setUnfavorite(for: self.identifer)
            completion(false)
        } catch {
            completion(true)
        }
    }
}
