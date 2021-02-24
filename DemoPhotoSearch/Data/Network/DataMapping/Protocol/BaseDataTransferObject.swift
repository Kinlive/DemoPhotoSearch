//
//  BaseDataTransferObject.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/24.
//

import Foundation

/// Data transfer object of response
protocol BaseResponseDTO: Decodable {
  /// mapping to domain's entities
  func toDomain<T: BaseEntities>() -> T
}

/// Data transfer object of request
protocol BaseRequestDTO: Encodable {
  associatedtype QueryT

  init(query: QueryT)
}
