//
//  AppFlowCoordinator.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit
import RxSwift
import RxCocoa

class AppFlowCoordinator: BaseCoordinator {

    private let bag = DisposeBag()

    let appDIContainer: AppDIContainer
    weak var tabBarController: UITabBarController?

    // hands sub coordinators
    private var searchCoordinator: SearchCoordinator!
    private var favoriteCoordinator: FavoriteCoordinator!

    init(tabBarController: UITabBarController, container: AppDIContainer) {
        self.tabBarController = tabBarController
        appDIContainer = container
    }

    override func start() -> Completable {

        // setup search page
        let searchContainer = appDIContainer.makeSearchDIContainer()
        let searchNavigation = UINavigationController()
        searchNavigation.tabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)

        searchCoordinator = searchContainer.makeSearchCoordinator(at: searchNavigation)

        coordinator(to: searchCoordinator)
            .subscribe()
            .disposed(by: bag)

        // setup favorite page
        let favoriteContainer = appDIContainer.makeFavoriteDIContainer()
        let favoriteNavigation = UINavigationController()
        favoriteNavigation.tabBarItem = UITabBarItem(title: "Favor", image: nil, selectedImage: nil)

        favoriteCoordinator = favoriteContainer.makeFavoriteCoordinator(navigationController: favoriteNavigation)

        coordinator(to: favoriteCoordinator)
            .subscribe()
            .disposed(by: bag)

        tabBarController?.viewControllers = [searchNavigation, favoriteNavigation]
        tabBarController?.selectedViewController = searchNavigation

        return .never()
    }
}
