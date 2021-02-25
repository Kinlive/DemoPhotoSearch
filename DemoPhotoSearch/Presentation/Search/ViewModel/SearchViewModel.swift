//
//  SearchViewModel.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import Foundation
import RxSwift

struct SearchViewModelActions {
    var showResult: (PhotosQuery) -> Void
}

struct SearchViewModelInput {
    let searchText: Observable<String>
    let perPages: Observable<String>
    let submit: Observable<Void>
}
struct SearchViewModelOutput {
    let canSearch: Observable<Bool>
}
protocol SearchViewModel {
    func transform(input: SearchViewModelInput) -> SearchViewModelOutput
}

final class DefaultSearchViewModel: SearchViewModel {

    private let bag = DisposeBag()
    var actions: SearchViewModelActions

    init(action: SearchViewModelActions) {
        self.actions = action
    }

    func transform(input: SearchViewModelInput) -> SearchViewModelOutput {

        let allInputs = Observable.combineLatest(
            input.searchText,
            input.perPages
        )

        let isCanSearch = allInputs
            .map { searchText, perPages in !(searchText.isEmpty || perPages.isEmpty ) }

        let searchInfo = allInputs
            .map { text, perPage in PhotosQuery(searchText: text, perPage: Int(perPage) ?? 0, page: 1) }


        searchInfo.sample(input.submit)
            .subscribe(onNext: { [weak self] query in
                self?.actions.showResult(query)
            })
            .disposed(by: bag)

        return SearchViewModelOutput(
            canSearch: isCanSearch
        )

    }
}
