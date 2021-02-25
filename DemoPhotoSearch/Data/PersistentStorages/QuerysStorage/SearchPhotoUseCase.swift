//
//  SearchPhotoUseCase.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/25.
//

import Foundation
import RxSwift

protocol SearchRemoteUseCase {
    func search(query: PhotosQuery) -> Observable<Photos>
}

final class DefaultSearchRemoteUseCase: SearchRemoteUseCase {

    private let service: SearchService

    init(service: SearchService) {
        self.service = service
    }

    func search(query: PhotosQuery) -> Observable<Photos> {

        return Observable.create { [weak self] observer -> Disposable in
            _ = self?.service.request(targetType: .searchPhotos(parameter: query), completion: { result in
                if let error = result.error {
                    observer.onError(error)
                    return
                } else if let photos: Photos = result.responseDTO?.toDomain() {
                    observer.onNext(photos)
                    observer.onCompleted()
                } else {
                    observer.onError(result.error!)
                }
            })

            return Disposables.create()
        }
    }
}
