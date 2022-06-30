//
//  CoreDataProvider.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/30.
//

import Foundation
import CoreData

final class CoreDataProvider {
    static let shared = CoreDataProvider()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError()
            }
        }

        return container
    }()

    private lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()

    func fetch<T>(request: NSFetchRequest<T>, predicate: NSPredicate? = nil) throws -> [T] {
        if let predicate = predicate {
            request.predicate = predicate
        }

        let data = try self.context.fetch(request)

        return data
    }

    func create(entityName: String, values: [String: Any]) throws {
        let context = self.context
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)

        if let entity = entity {
            let content = NSManagedObject(entity: entity, insertInto: context)
            values.forEach { (key, value) in
                content.setValue(value, forKey: key)
            }
        }

        try self.saveContext()
    }

    func update(object: NSManagedObject, values: [String: Any]) throws {
        values.forEach { (key, value) in
            object.setValue(value, forKey: key)

        }

        try self.saveContext()
    }

    func delete(object: NSManagedObject) throws {
        context.delete(object)

        try self.saveContext()
    }

    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try self.context.execute(delete)
            return true
        } catch {
            return false
        }
    }

    func saveContext() throws {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                let nserror = error as NSError
                throw DataSourceError.coreDataSaveFailure(nserror)
            }
        }
    }
}
