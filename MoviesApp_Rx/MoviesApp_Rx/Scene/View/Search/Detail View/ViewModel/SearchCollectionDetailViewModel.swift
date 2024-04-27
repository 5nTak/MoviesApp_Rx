//
//  SearchCollectionDetailViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/22/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct CollectionSectionModel: SectionModelType {
    var title: String
    var items: [DetailCollection]
}

extension CollectionSectionModel {
    typealias Item = DetailCollection
    
    init(original: CollectionSectionModel, items: [DetailCollection]) {
        self = original
        self.items = items
    }
}

final class SearchCollectionDetailViewModel {
    var coordinator: SearchCollectionDetailCoordinator?
    
    typealias CollectionSection = SectionModel<String, DetailCollection>
    
    let sections = BehaviorRelay<[CollectionSectionModel]>(value: [])
    
    private var id: Int
    var title: String
    private let searchUseCase: SearchUseCase
    let searchCollection = BehaviorRelay<[CollectionSection]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    init(id: Int, title: String, searchUseCase: SearchUseCase) {
        self.id = id
        self.title = title
        self.searchUseCase = searchUseCase
    }
    
    func showCollectionContents() {
        showCollectionDetails(id: id)
        searchCollection
            .map { contents in
                print(contents)
                return [ CollectionSectionModel(title: "", items: contents.first?.items ?? []) ]
            }
            .bind(to: sections)
            .disposed(by: disposeBag)
        print(sections)
        print(sections.value)
    }
    
    private func showCollectionDetails(id: Int) {
        self.searchUseCase.fetchDetailCollection(id: id)
            .asObservable()
            .map { [CollectionSection(model: "", items: $0)] }
            .debug()
            .bind(to: searchCollection)
            .disposed(by: disposeBag)
        print(searchCollection.value)
    }
}
