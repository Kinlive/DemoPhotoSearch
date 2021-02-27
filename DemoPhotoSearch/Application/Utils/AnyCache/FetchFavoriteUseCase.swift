//
//  FetchFavoriteUseCase.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/27.
//

import Foundation
import RxSwift

protocol FetchFavoriteUseCase {
    func fetchFavorite() -> Observable<[Photo]>
}

final class DefaultFetchFavoriteUseCase: FetchFavoriteUseCase {

    private let storage: FavoritesPhotosStorage

    init(storage: FavoritesPhotosStorage) {
        self.storage = storage
    }

    func fetchFavorite() -> Observable<[Photo]> {
        return Observable.create { [weak self] observer -> Disposable in

            self?.storage.fetchAllFavorite(completion: { (result) in
                switch result {
                case .success(let dicDTO):
                    observer.onNext(dicDTO.map { $0.toDomain() })
                    observer.onCompleted()

                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
}
