//
//  CoreDataStorage.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/25.
//

import CoreData

enum CoreDataStorageError: Error {
  case readError(Error)
  case saveError(Error)
  case deleteError(Error)
}

final class CoreDataStorage {
  static let shared = CoreDataStorage()

  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "CoreDataStorage")
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        assertionFailure("CoreDataStorage unresolve error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  // MARK: - Core data saving support
  /// Use on UIAppdelegate func applicationDidEnterBackground by shared.
  func saveContext() throws {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()

      } catch {
        throw error
      }
    }
  }

  func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
    persistentContainer.performBackgroundTask(block)
  }
}



