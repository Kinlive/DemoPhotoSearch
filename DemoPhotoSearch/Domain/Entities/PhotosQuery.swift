//
//  PhotosQuery.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/24.
//

import Foundation

struct PhotosQuery: Equatable {

  let searchText: String
  let perPage: Int
  let page: Int
  var createDate: Date?

}

extension PhotosQuery {
  func toDTO() -> SearchRequestDTO {
    return .init(query: self)
  }
}
