//
//  BaseCoordinator.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import Foundation
import RxSwift

class BaseCoordinator: NSObject {

  private var childCoordinators: [UUID : BaseCoordinator] = [:]
  private let identifier = UUID()

  func start() -> Completable {
    fatalError("\(#function) method should be implemented.")
  }

  private func store(coordinator: BaseCoordinator) {
    childCoordinators[coordinator.identifier] = coordinator
  }

  func free(coordinator: BaseCoordinator) {
    childCoordinators[coordinator.identifier] = nil
  }

  func coordinator(to coordinator: BaseCoordinator) -> Completable {
    store(coordinator: coordinator)

    return coordinator.start()
  }
}
