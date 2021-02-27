//
//  SavePhotoUseCase.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/27.
//

import Foundation
import RxSwift

protocol SaveFavoriteUseCase {
    func save(favorite photo: Photo, of request: PhotosQuery) -> Observable<Void>
}

final class DefaultSaveFavoriteUseCase: SaveFavoriteUseCase {

    private let storage: FavoritesPhotosStorage

    init(storage: FavoritesPhotosStorage) {
        self.storage = storage
    }

    func save(favorite photo: Photo, of request: PhotosQuery) -> Observable<Void> {

        return Observable<Void>.create { [weak self] observer -> Disposable in
            self?.storage.save(response: photo.toDTO(), of: request.toDTO(), completion: { error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }

}
