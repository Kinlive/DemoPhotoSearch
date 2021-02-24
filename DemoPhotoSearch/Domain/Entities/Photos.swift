//
//  Photos.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/24.
//

import Foundation

struct Photos: BaseEntities {
  typealias Identifier = String

  let id: Identifier
  let page, pages, perpage: Int
  let total: String?
  let photo: [Photo]
}


struct Photo: BaseEntities {
  typealias Identifier = String
  let id: Identifier
  let owner, secret, server: String?
  let farm: Int
  let title: String?
  let ispublic, isfriend, isfamily: Int
}

extension Photos {
  func toDTO() -> SearchResponseDTO.PhotosDTO {
    return .init(
      page: page,
      pages: pages,
      perpage: perpage,
      total: total,
      photo: photo.map { $0.toDTO() }
    )
  }
}

extension Photo {
  func toDTO() -> SearchResponseDTO.PhotosDTO.PhotoDTO {
    return .init(
      id: id,
      owner: owner,
      secret: secret,
      server: server,
      farm: farm,
      title: title,
      ispublic: ispublic,
      isfriend: isfriend,
      isfamily: isfamily
    )
  }
}
