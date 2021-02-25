//
//  SearchResultDIContainer.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit

protocol SearchResultDIContainerFactory {
    func makeResultCoordinator(at navigation: UINavigationController?) -> SearchResultCoordinator
    func makeSearchRemoteUseCase() -> SearchRemoteUseCase
}

class SearchResultDIContainer: SearchResultDIContainerFactory {

    typealias Dependencies = HasSearchService
    let dependencies: Dependencies
    let passValue: PhotosQuery

    init(dependencies: Dependencies, passValue: PhotosQuery) {
        self.dependencies = dependencies
        self.passValue = passValue
    }

    func makeResultCoordinator(at navigation: UINavigationController?) -> SearchResultCoordinator {

        return SearchResultCoordinator(navigationController: navigation, dependencies: self)
    }

    func makeSearchRemoteUseCase() -> SearchRemoteUseCase {
        return DefaultSearchRemoteUseCase(service: dependencies.searchService)
    }

}

extension SearchResultDIContainer: SearchResultCoordinatorDependencies {
    func makeSearchResultViewController() -> SearchResultViewController {
        let viewModel = DefaultSearchResultViewModel(passValue: passValue, useCase: makeSearchRemoteUseCase())
        return SearchResultViewController.instantiate(viewModel: viewModel)
    }
}
