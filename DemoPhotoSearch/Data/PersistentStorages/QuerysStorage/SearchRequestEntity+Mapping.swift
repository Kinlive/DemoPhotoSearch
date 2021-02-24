//
//  SearchRequestEntity+Mapping.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/25.
//

import Foundation
import CoreData

extension SearchRequestEntity {
  func toDTO() -> SearchRequestDTO {
    return .init(query: toDomain())
  }

  func toDomain() -> PhotosQuery {

    return .init(
      searchText: text ?? "",
      perPage: Int(perPage),
      page: Int(page),
      createDate: createTime)
  }
}

extension SearchRequestDTO {
  func toEntity(in context: NSManagedObjectContext) -> SearchRequestEntity {
    let entity: SearchRequestEntity = .init(context: context)
    entity.page = Int32(page)
    entity.perPage = Int32(perPage)
    entity.text = text
    entity.createTime = Date()

    return entity
  }
}
