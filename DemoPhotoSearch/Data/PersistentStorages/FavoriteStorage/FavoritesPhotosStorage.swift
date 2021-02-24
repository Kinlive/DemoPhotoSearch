//
//  FavoritesPhotosStorage.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/25.
//

import Foundation

protocol FavoritesPhotosStorage {
  func save(response: SearchResponseDTO.PhotosDTO.PhotoDTO, of request: SearchRequestDTO, completion: @escaping (CoreDataStorageError?) -> Void)
  func fetchAllFavorite(completion: @escaping (Result<[String : [SearchResponseDTO.PhotosDTO.PhotoDTO]], CoreDataStorageError>) -> Void)
  func remove(response: SearchResponseDTO.PhotosDTO.PhotoDTO, completion: @escaping (CoreDataStorageError?) -> Void)
}
