//
//  AppDependency.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import Foundation

// protocol has some dependency
protocol HasSearchService {
    var searchService: SearchService { get }
}
protocol HasCoreDataStorage {
    var coreDataStorage: FavoritesPhotosStorage { get }
}

struct AppDependency: HasSearchService, HasCoreDataStorage {

    var searchService: SearchService
    var coreDataStorage: FavoritesPhotosStorage

    init(
        searchService: SearchService,
        coreDataStorage: FavoritesPhotosStorage
    ) {
        self.searchService = searchService
        self.coreDataStorage = coreDataStorage
    }
}

