//
//  SearchResponseDTO+Mapping.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/24.
//

import Foundation

// MARK: - Search response data transfer object
struct SearchResponseDTO: BaseResponseDTO {
  typealias DomainT = Photos

  let photos: PhotosDTO?
  let stat: String
}

// MARK: - Photos
extension SearchResponseDTO {
  struct PhotosDTO: BaseResponseDTO {
    typealias DomainT = Photos

    let page, pages, perpage: Int
    let total: String?
    let photo: [PhotoDTO]
  }
}

// MARK: - Photo
extension SearchResponseDTO.PhotosDTO {
  struct PhotoDTO: BaseResponseDTO {
    typealias DomainT = Photo

    let id: String
    let owner, secret, server: String?
    let farm: Int
    let title: String?
    let ispublic, isfriend, isfamily: Int
  }
}

// MARK: - Mapping to domain's entities
extension SearchResponseDTO {
  func toDomain<T>() -> T where T : BaseEntities {
    return photos!.toDomain()
  }
}

extension SearchResponseDTO.PhotosDTO {
  func toDomain<T>() -> T where T : BaseEntities {
    return Photos(
      id: UUID().uuidString,
      page: page,
      pages: pages,
      perpage: perpage,
      total: total,
      photo: photo.map { $0.toDomain() }
    ) as! T
  }
}

extension SearchResponseDTO.PhotosDTO.PhotoDTO {
  func toDomain<T>() -> T where T : BaseEntities {
    return Photo(
      id: id,
      owner: owner,
      secret: secret,
      server: server,
      farm: farm,
      title: title,
      ispublic: ispublic,
      isfriend: isfriend,
      isfamily: isfamily) as! T
  }
}
