//
//  SearchRequestDTO+Mapping.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/24.
//

import Foundation

struct SearchRequestDTO: BaseRequestDTO {
  typealias QueryT = PhotosQuery

  enum CodingKeys: String, CodingKey {
    case text
    case perPage = "per_page"
    case page
  }

  let text: String
  let perPage: Int
  let page: Int
  var createDate: Date?

  init(query: PhotosQuery) {
    self.text = query.searchText
    self.perPage = query.perPage
    self.page = query.page
    self.createDate = query.createDate
  }

}

extension SearchRequestDTO {
  func toDomain() -> PhotosQuery {
    return PhotosQuery(
      searchText: text,
      perPage: perPage,
      page: page,
      createDate: createDate)
  }
}
