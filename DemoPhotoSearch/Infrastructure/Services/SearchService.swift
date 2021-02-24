//
//  SearchService.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/24.
//

import Foundation
import Moya

final class SearchService: DefaultService<FlickrAPIType, SearchResponseDTO> {

  // Override request method to do something you want of the subclass of DefaultService.
  override func request(targetType: FlickrAPIType, completion: @escaping (DefaultService<FlickrAPIType, SearchResponseDTO>.ReturnValueBase) -> Void) -> Cancellable {
    super.request(targetType: targetType) { result in

      completion(result)
    }
  }
}
