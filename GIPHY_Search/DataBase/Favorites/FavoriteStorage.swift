//
//  FavoriteStorage.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/30.
//

import Foundation
import CoreData

final class FavoriteStorage {
    private let coreDataProvider: CoreDataProvider

    init(coreDataProvider: CoreDataProvider = .shared) {
        self.coreDataProvider = coreDataProvider
    }

    func isFavorite(
        of identifier: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        do {
            let result = try self.coreDataProvider.fetch(request: Favorites.fetchRequest())
                .map { $0.identifier }
            completion(.success(result.contains(identifier)))
        } catch let error {
            completion(.failure(error))
        }
    }

    func setFavorite(for identifier: String) throws {
        try self.coreDataProvider.create(
            entityName: String(describing: Favorites.self),
            values: ["identifier" : identifier]
        )
    }

    func setUnfavorite(for identifier: String) throws {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        let objects = try self.coreDataProvider.fetch(
            request: Favorites.fetchRequest(),
            predicate: predicate
        )
        guard let object = objects.first else {
            return
        }

        try self.coreDataProvider.delete(object: object)
    }
}
