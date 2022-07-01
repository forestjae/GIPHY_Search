//
//  SearchQueryStorage.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/07/01.
//

import Foundation
import CoreData

final class SearchQueryStorage {
    private let coreDataProvider: CoreDataProvider

    init(coreDataProvider: CoreDataProvider = .shared) {
        self.coreDataProvider = coreDataProvider
    }

    func fetchQuery(completion: @escaping (Result<[String], Error>) -> Void) {
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        let request = SearchQuery.fetchRequest()
        request.sortDescriptors = [sort]
        do {
            let result = try self.coreDataProvider.fetch(request: request)
                .compactMap { $0.query }
            completion(.success(result))
        } catch let error {
            completion(.failure(error))
        }
    }

    func saveQuery(of query: String, createdAt: Date = Date()) throws {
        let predicate = NSPredicate(format: "query == %@", query)
        let objects = try self.coreDataProvider.fetch(
            request: SearchQuery.fetchRequest(),
            predicate: predicate
        )
        if let object = objects.first {
            try self.coreDataProvider.update(
                object: object,
                values:  ["query" : query, "createdAt": createdAt]
            )
        } else {
            try self.coreDataProvider.create(
                entityName: String(describing: SearchQuery.self),
                values: ["query" : query, "createdAt": createdAt]
            )
        }
    }

    func deleteQuery(of query: String) throws {
        let predicate = NSPredicate(format: "query == %@", query)
        let objects = try self.coreDataProvider.fetch(
            request: SearchQuery.fetchRequest(),
            predicate: predicate
        )
        guard let object = objects.first else {
            return
        }

        try self.coreDataProvider.delete(object: object)
    }
}
