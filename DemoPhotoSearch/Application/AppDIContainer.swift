//
//  AppDIContainer.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import Foundation
import Moya

protocol AppDIContainerFactory {
    func makeSearchDIContainer() -> SearchDIContainer
    func makeFavoriteDIContainer() -> FavoriteDIContainer
}

class AppDIContainer: AppDIContainerFactory {

    lazy var appDependency: AppDependency = {
        let service = SearchService(provider: MoyaProvider<FlickrAPIType>())
        let dependency = AppDependency(searchService: service)
        return dependency
    }()

    func makeSearchDIContainer() -> SearchDIContainer {
        return SearchDIContainer(dependencies: appDependency)
    }

    func makeFavoriteDIContainer() -> FavoriteDIContainer {
        return FavoriteDIContainer(dependencies: appDependency)
    }

}
