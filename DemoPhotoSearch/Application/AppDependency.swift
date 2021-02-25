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

struct AppDependency: HasSearchService {

    var searchService: SearchService

    init(searchService: SearchService) {
        self.searchService = searchService
    }
}

