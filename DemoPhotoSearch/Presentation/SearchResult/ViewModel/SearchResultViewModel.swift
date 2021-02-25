//
//  SearchResultViewModel.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import Foundation
import RxSwift

struct SearchResultInput {
    let photoSelected: PublishSubject<(Bool, IndexPath)> // undo
    let scrollToBottom: PublishSubject<Void> // undo
}
struct SearchResultOutput {
    let saved: Observable<IndexPath> // undo
    let removed: Observable<Void> // undo
    let photos: Observable<Photos>
}

protocol SearchResultViewModel {
    func transform(input: SearchResultInput) -> SearchResultOutput
}

final class DefaultSearchResultViewModel: SearchResultViewModel {

    private var passValue: PhotosQuery
    private let useCase: SearchRemoteUseCase


    init(passValue: PhotosQuery, useCase: SearchRemoteUseCase) {
        self.passValue = passValue
        self.useCase = useCase
    }

    func transform(input: SearchResultInput) -> SearchResultOutput {

//        input.scrollToBottom
//            .throttle(.seconds(2), scheduler: MainScheduler.instance)
//            .map { }

        return SearchResultOutput(
            saved: Observable.just(IndexPath(item: 0, section: 0)),
            removed: Observable.just(()),
            photos: searchPhotosUseCase()
        )
    }

    private func searchPhotosUseCase() -> Observable<Photos> {
        return useCase.search(query: passValue)
    }
}
