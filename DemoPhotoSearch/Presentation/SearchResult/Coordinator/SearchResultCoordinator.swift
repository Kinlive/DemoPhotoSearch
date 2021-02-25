//
//  SearchResultCoordinator.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchResultCoordinatorDependencies {
    func makeSearchResultViewController() -> SearchResultViewController
}

class SearchResultCoordinator: BaseCoordinator {

    private let bag = DisposeBag()
    private weak var navigationController: UINavigationController?
    private let dependencies: SearchResultCoordinatorDependencies

    init(navigationController: UINavigationController?, dependencies: SearchResultCoordinatorDependencies) {
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

        let resultVC = dependencies.makeSearchResultViewController()
        resultVC.navigationItem.title = "Result"

        navigationController?.pushViewController(resultVC, animated: true)

        return subject.ignoreElements()
    }
}
