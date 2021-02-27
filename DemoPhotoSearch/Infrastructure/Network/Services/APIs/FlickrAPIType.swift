//
//  FlickrSearchType.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/25.
//

import Foundation
import Moya

enum FlickrAPIType {
  case searchPhotos(parameter: PhotosQuery)
}

extension FlickrAPIType: TargetType {

  var baseURL: URL { URL(string: "https://www.flickr.com/services/")! }

  var path: String { "rest/" }

  var method: Moya.Method { .post }

  var sampleData: Data { sampleJSON.data(using: .utf8)! }

  var task: Task {
    switch self {
    case .searchPhotos(let parameter):
      let dto = SearchRequestDTO(query: parameter)
      var dic = (try? dto.asDictionary()) ?? [:]

      // additional query parameter
      dic["method"] = "flickr.photos.search"
      dic["api_key"] = "2d56edc1b27ddecc287336edac52ddba"
      dic["format"] = "json"
      dic["nojsoncallback"] = "1"
      return .requestCompositeParameters(bodyParameters: [:], bodyEncoding: JSONEncoding.default, urlParameters: dic)
    }
  }

  var headers: [String : String]? {
    [
      "Content-Type" : "application/json"
    ]
  }
}

private let sampleJSON: String =
"""
  {
      "photos": {
          "page": 1,
          "pages": 21596,
          "perpage": 10,
          "total": "215951",
          "photo": [
              {
                  "id": "9999999999",
                  "owner": "sample owner",
                  "secret": "sample secret",
                  "server": "sample server",
                  "farm": 66,
                  "title": "sample use ",
                  "ispublic": 1,
                  "isfriend": 0,
                  "isfamily": 0
              }
          ]
      },
      "stat": "ok"
  }
"""
