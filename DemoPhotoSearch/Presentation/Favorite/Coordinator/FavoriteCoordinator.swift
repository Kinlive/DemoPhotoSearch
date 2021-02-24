//
//  FavoriteCoordinator.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit
import RxSwift
import RxCocoa


protocol FavoriteCoordinatorDependencies {
    func makeFavoriteViewController() -> FavoriteViewController
}

class FavoriteCoordinator: BaseCoordinator {

    private let bag = DisposeBag()
    let dependencies: FavoriteCoordinatorDependencies
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController, dependencies: FavoriteCoordinatorDependencies) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }


    override func start() -> Completable {
        let subject = PublishSubject<Void>()

        let vc = dependencies.makeFavoriteViewController()
        vc.navigationItem.title = "Favorite photos"
        navigationController?.pushViewController(vc, animated: true)

        navigationController?.rx.delegate
            .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in }
            .bind(to: subject)
            .disposed(by: bag)

        return subject.ignoreElements()
    }
}
