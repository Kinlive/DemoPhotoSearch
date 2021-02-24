//
//  AppDIContainer.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import Foundation


protocol AppDIContainerFactory {
    func makeSearchDIContainer() -> SearchDIContainer
    func makeFavoriteDIContainer() -> FavoriteDIContainer
}

class AppDIContainer: AppDIContainerFactory {

    let appDependency = AppDependency()

    func makeSearchDIContainer() -> SearchDIContainer {
        return SearchDIContainer(dependencies: appDependency)
    }

    func makeFavoriteDIContainer() -> FavoriteDIContainer {
        return FavoriteDIContainer(dependencies: appDependency)
    }

}
