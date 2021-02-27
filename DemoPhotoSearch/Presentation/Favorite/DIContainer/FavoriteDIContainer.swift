//
//  FavoriteDIContainer.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit

protocol FavoriteDIContainerFactory {
    // make favorite VC
    func makeFavoriteCoordinator(navigationController: UINavigationController) -> FavoriteCoordinator
    func makeUseCase() -> UseCases
}

class FavoriteDIContainer {

    typealias Dependencies = AppDependency
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
    }
}

extension FavoriteDIContainer: FavoriteDIContainerFactory {
    func makeFavoriteCoordinator(navigationController: UINavigationController) -> FavoriteCoordinator {

        return FavoriteCoordinator(navigationController: navigationController, dependencies: self)
    }

    func makeUseCase() -> UseCases {
        return UseCases(fetchFavoriteUseCase: DefaultFetchFavoriteUseCase(storage: dependencies.coreDataStorage))
    }
}

extension FavoriteDIContainer: FavoriteCoordinatorDependencies {

    func makeFavoriteViewController() -> FavoriteViewController {

        return FavoriteViewController.instantiate(viewModel: DefaultFavoriteViewModel(useCases: makeUseCase()))
    }

}
