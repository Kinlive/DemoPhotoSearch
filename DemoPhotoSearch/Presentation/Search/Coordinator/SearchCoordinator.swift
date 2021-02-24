//
//  SearchCoordinator.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchCoordinatorDependencies {
    func makeSearchViewController() -> SearchViewController
    func makeResultDIContainer() -> SearchResultDIContainer
}

class SearchCoordinator: BaseCoordinator {

    private let bag = DisposeBag()
    let dependencies: SearchCoordinatorDependencies
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController, dependencies: SearchCoordinatorDependencies ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    override func start() -> Completable {
        let subject = PublishSubject<Void>()

        navigationController?.rx.delegate
            .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in }
            .bind(to: subject)
            .disposed(by: bag)

        let searchVC = dependencies.makeSearchViewController()
        searchVC.navigationItem.title = "Search photos"

        navigationController?.pushViewController(searchVC, animated: true)

        return subject.ignoreElements()
    }

}
