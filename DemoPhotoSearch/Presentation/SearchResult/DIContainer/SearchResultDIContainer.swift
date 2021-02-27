//
//  SearchResultDIContainer.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit

protocol SearchResultDIContainerFactory {
    func makeResultCoordinator(at navigation: UINavigationController?) -> SearchResultCoordinator
    func makeUseCase() -> UseCases
}

class SearchResultDIContainer: SearchResultDIContainerFactory {

    typealias Dependencies = HasSearchService & HasCoreDataStorage
    let dependencies: Dependencies
    let passValue: PhotosQuery

    init(dependencies: Dependencies, passValue: PhotosQuery) {
        self.dependencies = dependencies
        self.passValue = passValue
    }

    func makeResultCoordinator(at navigation: UINavigationController?) -> SearchResultCoordinator {

        return SearchResultCoordinator(navigationController: navigation, dependencies: self)
    }

    func makeUseCase() -> UseCases {
        let searchUseCase = DefaultSearchRemoteUseCase(service: dependencies.searchService)
        let saveUseCase = DefaultSaveFavoriteUseCase(storage: dependencies.coreDataStorage)
        return UseCases(searchRemoteUseCase: searchUseCase, saveFavoriteUseCase: saveUseCase)
    }

}

extension SearchResultDIContainer: SearchResultCoordinatorDependencies {
    func makeSearchResultViewController() -> SearchResultViewController {
        let viewModel = DefaultSearchResultViewModel(passValue: passValue, useCase: makeUseCase())
        return SearchResultViewController.instantiate(viewModel: viewModel)
    }
}
