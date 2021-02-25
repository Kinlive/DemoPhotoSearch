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
    func makeSearchViewController(action: SearchViewModelActions) -> SearchViewController
    func makeResultDIContainer(passValue: PhotosQuery) -> SearchResultDIContainer
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

        let action = SearchViewModelActions(showResult: actionToResultPage(query:))

        let searchVC = dependencies.makeSearchViewController(action: action)
        searchVC.navigationItem.title = "Search photos"

        navigationController?.pushViewController(searchVC, animated: true)

        return subject.ignoreElements()
    }

    private func actionToResultPage(query: PhotosQuery) {
        let container = dependencies.makeResultDIContainer(passValue: query)
        let resultCoordinator = container.makeResultCoordinator(at: navigationController)

        _ = coordinator(to: resultCoordinator)

    }

}
