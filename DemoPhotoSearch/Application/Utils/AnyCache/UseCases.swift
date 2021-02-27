//
//  UseCases.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/27.
//

import Foundation

protocol HasPhotosRemoteSearchUseCase {
    var searchRemoteUseCase: SearchRemoteUseCase? { get }
}

protocol HasSaveFavoriteUseCase {
    var saveFavoriteUseCase: SaveFavoriteUseCase? { get }
}

protocol HasFetchFavoriteUseCase {
    var fetchFavoriteUseCase: FetchFavoriteUseCase? { get }
}

struct UseCases: HasPhotosRemoteSearchUseCase, HasSaveFavoriteUseCase, HasFetchFavoriteUseCase {

    var saveFavoriteUseCase: SaveFavoriteUseCase?
    var searchRemoteUseCase: SearchRemoteUseCase?
    var fetchFavoriteUseCase: FetchFavoriteUseCase?

    init(searchRemoteUseCase: SearchRemoteUseCase? = nil,
         saveFavoriteUseCase: SaveFavoriteUseCase? = nil,
         fetchFavoriteUseCase: FetchFavoriteUseCase? = nil) {

        self.searchRemoteUseCase = searchRemoteUseCase
        self.saveFavoriteUseCase = saveFavoriteUseCase
        self.fetchFavoriteUseCase = fetchFavoriteUseCase
    }
}
