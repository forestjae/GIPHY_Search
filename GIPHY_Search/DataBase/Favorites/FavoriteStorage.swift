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
        of identifer: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        do {
            let result = try self.coreDataProvider.fetch(request: Favorites.fetchRequest())
                .map { $0.identifier }
            completion(.success(result.contains(identifer)))
        } catch let error {
            completion(.failure(error))
        }
    }

    func setFavorite(for identifer: String) throws {
        try self.coreDataProvider.create(
            entityName: String(describing: Favorites.self),
            values: ["identifier" : identifer]
        )
    }

    func setUnfavorite(for identifer: String) throws {
        let predicate = NSPredicate(format: "identifier == %@", identifer)
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
