//
//  FavoriteViewModel.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import Foundation
import RxSwift

struct FavoriteInput {
    let viewWillAppear: Observable<Bool>
}

struct FavoriteOutput {
    let photos: Observable<[Photo]>
}

protocol FavoriteViewModel {
    func transform(input: FavoriteInput) -> FavoriteOutput
}

class DefaultFavoriteViewModel: FavoriteViewModel {

    typealias UseCases = HasFetchFavoriteUseCase

    // MARK: - Properties
    private let useCases: UseCases

    init(useCases: UseCases) {
        self.useCases = useCases
    }

    func transform(input: FavoriteInput) -> FavoriteOutput {

        let result = input.viewWillAppear.debug("viewWillAppear")
            .map { [weak self] _ in self?.fetchFavoriteUseCase() }
            .filter { $0 != nil }
            .map { $0! }
            .flatMap { $0 }
            .debug()


        return FavoriteOutput(photos: result)

    }

    private func fetchFavoriteUseCase() -> Observable<[Photo]> {
        guard let useCase = useCases.fetchFavoriteUseCase else {
            return .error(NSError(
                domain: "useCase not found",
                code: -990,
                userInfo: nil)
            )
        }

        return useCase.fetchFavorite()
    }

}
