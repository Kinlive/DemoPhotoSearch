//
//  CoreDataFavoritesPhotosStorage.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/25.
//

import CoreData

class CoreDataFavoritesPhotosStorage {

  private let coreDataStorage: CoreDataStorage = CoreDataStorage.shared

  private func fetchAllRequest() -> NSFetchRequest<FavoritePhotoEntity> {
    let request: NSFetchRequest = FavoritePhotoEntity.fetchRequest()

    // Notice: If attribute was bool, must use NSNumber wrap of bool or use %d to compare int: true -> 1, false -> 0

    return request
  }

  private func deleteFavorite(for response: SearchResponseDTO.PhotosDTO.PhotoDTO, in context: NSManagedObjectContext) throws {
    let request = fetchAllRequest()

    do {
      let results = try context.fetch(request)
      results
        .filter { $0.id == response.id }
        .forEach { context.delete($0) }

    } catch {
      throw error
    }
  }

  private func findSameRequest(for request: SearchRequestDTO, in context: NSManagedObjectContext) throws -> SearchRequestEntity? {
    let fetchRequest: NSFetchRequest = SearchRequestEntity.fetchRequest()
    do {
      let results = try context.fetch(fetchRequest)
      return results
        .filter { $0.text == request.text }
        .first ?? request.toEntity(in: context) // if not found same request on storaged then new one for it

    } catch {
      throw error
    }
  }

  private func findSamePhoto(for response: SearchResponseDTO.PhotosDTO.PhotoDTO, in context: NSManagedObjectContext) throws -> FavoritePhotoEntity? {
    let fetchRequest: NSFetchRequest = FavoritePhotoEntity.fetchRequest()

    do {
      let results = try context.fetch(fetchRequest)
      return results
        .filter { $0.id == response.id }
        .first ?? response.toFavoriteEntity(in: context)  // if not found same request on storaged then new one for it

    } catch {
      throw error
    }
  }

}

extension CoreDataFavoritesPhotosStorage: FavoritesPhotosStorage {
  func save(response: SearchResponseDTO.PhotosDTO.PhotoDTO,
            of request: SearchRequestDTO,
            completion: @escaping (CoreDataStorageError?) -> Void) {

    coreDataStorage.performBackgroundTask { [weak self] context in
      do {
        // find storaged response who same with import's response that edit favorite in context.
        let photoEntity = try self?.findSamePhoto(for: response, in: context)

        // dependency with request
        photoEntity?.request = try self?.findSameRequest(for: request, in: context)

        try context.save()
        completion(nil)

      } catch {
        completion(.saveError(error))
      }
    }
  }

  func fetchAllFavorite(completion: @escaping (Result<[SearchResponseDTO.PhotosDTO.PhotoDTO], CoreDataStorageError>) -> Void) {
    coreDataStorage.performBackgroundTask { context in
      do {
        let fetchAllRequest = self.fetchAllRequest()
        let responseEntity = try context.fetch(fetchAllRequest)

        let transfer = responseEntity
            .map { $0.toDTO() }

        completion(.success(transfer))

      } catch {
        completion(.failure(CoreDataStorageError.readError(error)))
      }
    }
  }

  func remove(response: SearchResponseDTO.PhotosDTO.PhotoDTO, completion: @escaping (CoreDataStorageError?) -> Void) {
    coreDataStorage.performBackgroundTask { [weak self] context in
      do {
        try self?.deleteFavorite(for: response, in: context)
        try context.save()

        completion(nil)
      } catch {
        completion(.deleteError(error))
      }
    }
  }
}
