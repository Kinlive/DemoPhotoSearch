//
//  DefaultService.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/24.
//

import Foundation
import Moya

/** Implemented service with protocol BaseService

    Create other service inherit the DefaultService that generic type to conform **Moya.TargetType**, **BaseResponseDTO**, **BaseEntities** to assign your query object, response data transfer objects and final converted domain objects
 */
class DefaultService<TargetTypeT: TargetType,
                     ResponseDTO: BaseResponseDTO>: BaseService {

  typealias TargetTypeBase = TargetTypeT
  typealias ReturnValueBase = (responseDTO: BaseResponseDTO?, error: Error?)
  typealias CancellableBase = Cancellable

  var provider: MoyaProvider<TargetTypeT>

  required init(provider: MoyaProvider<TargetTypeT>) {
    self.provider = provider
   }

  @discardableResult
  func request(targetType: TargetTypeT, completion: @escaping (ReturnValueBase) -> Void) -> Cancellable {
    return provider.request(targetType) { (result) in
      completion(self.handle(result))
    }
  }

  private func handle(_ result: Result<Moya.Response, MoyaError>) -> ReturnValueBase {
    switch result {
    case .success(let response):
      do {
        let jsonObject = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers)
        let jsonPretty = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        print(String(data: jsonPretty, encoding: .utf8) ?? "")

        return (try response.map(ResponseDTO.self), nil)

      } catch let error { return (nil, error) }

    case .failure(let moyaError):
      return (nil, moyaError)
    }
  }
}
