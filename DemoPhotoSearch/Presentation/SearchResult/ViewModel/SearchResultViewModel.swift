//
//  SearchResultViewModel.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import Foundation
import RxSwift

struct SearchResultInput {
    let fetchPhotos: Observable<Void>
    let photoSelected: Observable<IndexPath>
    let scrollToBottom: Observable<Bool>
}
struct SearchResultOutput {
    let saved: Observable<IndexPath> // undo
    let photos: Observable<Photos>
}

protocol SearchResultViewModel {
    func transform(input: SearchResultInput) -> SearchResultOutput
}

final class DefaultSearchResultViewModel: SearchResultViewModel {
    typealias UseCases = HasPhotosRemoteSearchUseCase & HasSaveFavoriteUseCase

    let bag = DisposeBag()
    private var passValue: PhotosQuery
    private let useCase: UseCases

    private var currentPage: Int = 0
    private var currentPhotos: Photos?

    init(passValue: PhotosQuery, useCase: UseCases) {
        self.passValue = passValue
        self.useCase = useCase
        currentPage = passValue.page
    }

    func transform(input: SearchResultInput) -> SearchResultOutput {

        let onFetchNextPage = input.scrollToBottom
            .do(onNext: { [weak self] _ in self?.currentPage += 1 })
            .map { [weak self] _ in (self?.passValue, self?.currentPage) }
            .filter { $0 != nil && $1 != nil }
            .map { query, currentPage in
                PhotosQuery(searchText: query!.searchText, perPage: query!.perPage, page: currentPage!, createDate: query!.createDate)
            }
            .map { [weak self] nextPageQuery in self?.searchPhotosUseCase(query: nextPageQuery) }
            .filter { $0 != nil }
            .flatMap { $0! }

        let totals = onFetchNextPage
            .filter { [weak self] _ in self?.currentPhotos != nil }
            .map { [weak self] in ($0, self!.currentPhotos!) }
            .map { (next, current) -> Photos in
                let total = Photos(
                    id: current.id,
                    page: next.page,
                    pages: next.pages,
                    perpage: next.perpage,
                    total: next.total,
                    photo: current.photo + next.photo
                )
                return total
            }


        let reload = input.fetchPhotos
            .do(onNext: { [weak self] _ in self?.currentPage = 1 })
            .map { [weak self] _ in self?.passValue }
            .filter { $0 != nil }
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .map { [weak self] query in self?.searchPhotosUseCase(query: query!) }
            .filter { $0 != nil }
            .flatMap { $0! }
            .observeOn(MainScheduler.instance)

        let newPhotos = Observable.merge(reload, totals)
            .do(onNext: { [weak self] photos in self?.currentPhotos = photos })

        let saveFavorite = input.photoSelected.withLatestFrom(newPhotos) { indexPath, photos in
                return (indexPath, photos.photo[indexPath.row])
            }
            .flatMap { [weak self] (indexPath, photo) in
                return (self?.savePhotoUseCase(photo: photo) ?? .empty())
                    .map { _ in indexPath }
            }

        return SearchResultOutput(
            saved: saveFavorite,
            photos: newPhotos
        )
    }

    private func searchPhotosUseCase(query: PhotosQuery) -> Observable<Photos> {
        guard let useCase = useCase.searchRemoteUseCase else {
            return .error(NSError(
                domain: "useCase not found",
                code: -990,
                userInfo: nil)
            )
        }
        return useCase.search(query: query)
    }

    private func savePhotoUseCase(photo: Photo) -> Observable<Void> {
        guard let useCase = useCase.saveFavoriteUseCase else {
            return .error(NSError(
                domain: "useCase not found",
                code: -990,
                userInfo: nil)
            )
        }
        return useCase.save(favorite: photo, of: passValue)
    }
}
