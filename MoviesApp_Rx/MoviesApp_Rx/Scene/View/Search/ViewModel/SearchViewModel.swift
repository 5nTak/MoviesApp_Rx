//
//  SearchViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol ItemData { }

extension Movie: ItemData { }
extension Collection: ItemData { }

struct SearchSectionModel {
    var title: String
    var items: [Item]
}

extension SearchSectionModel: SectionModelType {
    typealias Item = ItemData
    
    init(original: SearchSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

final class SearchViewModel {
    typealias SearchSection = SectionModel<String, ItemData>
    
    let sections = BehaviorRelay<[SearchSectionModel]>(value: [])
    var searchText = BehaviorRelay<String>(value: "")
    var coordinator: SearchCoordinator?
    
    private let searchMovieUseCase: SearchUseCase
    private let disposeBag = DisposeBag()
    
    private let searchMovies = BehaviorRelay<[SearchSection]>(value: [])
    private let searchCollections = BehaviorRelay<[SearchSection]>(value: [])
    
    init(searchMovieUseCase: SearchUseCase) {
        self.searchMovieUseCase = searchMovieUseCase
        searchText
            .distinctUntilChanged()
            .subscribe { [weak self] text in
                self?.showSearchResult()
            }
            .disposed(by: disposeBag)
    }
    
    func showSearchResult() {
        DispatchQueue.main.async { [weak self] in
            self?.searchMovies(searchText: self?.searchText.value ?? "")
            self?.searchCollections(searchText: self?.searchText.value ?? "")
        }
        
        Observable.combineLatest(searchMovies, searchCollections)
            .map { movies, collections in
                return [
                    SearchSectionModel(title: SearchSectionKind.movie.description, items: movies.first?.items ?? []),
                    SearchSectionModel(title: SearchSectionKind.collection.description, items: collections.first?.items ?? [])
                ]
            }
            .bind(to: sections)
            .disposed(by: disposeBag)
    }
    
    private func searchMovies(searchText: String) {
        searchMovieUseCase.fetchSearchMovie(searchText: searchText)
            .asObservable()
            .map { [SearchSection(model: SearchSectionKind.movie.description, items: $0)] }
            .bind(to: searchMovies)
            .disposed(by: disposeBag)
    }
    
    private func searchCollections(searchText: String) {
        searchMovieUseCase.fetchSearchCollection(searchText: searchText)
            .asObservable()
            .map { [SearchSection(model: SearchSectionKind.collection.description, items: $0)] }
            .bind(to: searchCollections)
            .disposed(by: disposeBag)
    }
}
