//
//  SearchDIContainer.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit

protocol SearchDIContainerFactory {
    func makeSearchCoordinator(at navigationController: UINavigationController) -> SearchCoordinator

    // func makeSearchViewModelUseCases() -> UseCases
    func makeSearchViewModel(with actions: SearchViewModelActions) -> SearchViewModel
}
class SearchDIContainer {

    typealias Dependencies = AppDependency

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

}

extension SearchDIContainer: SearchDIContainerFactory {
    func makeSearchCoordinator(at navigationController: UINavigationController) -> SearchCoordinator {

        return SearchCoordinator(navigationController: navigationController, dependencies: self)
    }

    func makeSearchViewModel(with actions: SearchViewModelActions) -> SearchViewModel {

        return DefaultSearchViewModel(action: actions)
    }
}

extension SearchDIContainer: SearchCoordinatorDependencies {
    func makeResultDIContainer(passValue: PhotosQuery) -> SearchResultDIContainer {
        return SearchResultDIContainer(dependencies: dependencies, passValue: passValue)
    }

    func makeSearchViewController(action: SearchViewModelActions) -> SearchViewController {

        return SearchViewController.instantiate(viewModel: DefaultSearchViewModel(action: action))
    }

}
