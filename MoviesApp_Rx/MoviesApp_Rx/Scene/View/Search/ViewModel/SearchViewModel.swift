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

enum SearchSectionItem {
    case recentlyItem(movie: String)
    case discoverPopular(movies: String)
    case discoverTopRated(movies: String)
    case genres(kind: Genre)
    case searchMovies(movie: Movie)
    case searchCollections(collection: Collection)
}

struct SearchSectionModel {
    var title: String
    var items: [SearchSectionItem]
}

extension SearchSectionModel: SectionModelType {
    typealias Item = SearchSectionItem
    
    init(original: SearchSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

final class SearchViewModel {
    typealias SearchSection = SectionModel<String, SearchSectionItem>
    
    let sections = BehaviorRelay<[SearchSectionModel]>(value: [])
    let genres = BehaviorRelay<[Genre]>(value: [])
    let isSearchActive = BehaviorRelay<Bool>(value: false)
    var searchText = BehaviorRelay<String>(value: "")
    var coordinator: SearchCoordinator?
    
    private let movieUseCase: MovieUseCase
    private let searchMovieUseCase: SearchUseCase
    private let disposeBag = DisposeBag()
    
    private let searchMovies = BehaviorRelay<[SearchSection]>(value: [])
    private let searchCollections = BehaviorRelay<[SearchSection]>(value: [])
    
    init(movieUseCase: MovieUseCase, searchMovieUseCase: SearchUseCase) {
        self.movieUseCase = movieUseCase
        self.searchMovieUseCase = searchMovieUseCase
        searchText
            .distinctUntilChanged()
            .subscribe { [weak self] text in
                self?.isSearchActive.accept(!text.isEmpty)
                self?.showSearchResult()
            }
            .disposed(by: disposeBag)
        
        fetchGenre()
    }
    
    private func fetchGenre() {
        movieUseCase.fetchGenres()
            .asObservable()
            .bind(to: genres)
            .disposed(by: disposeBag)
    }
    
    func showSearchResult() {
        if searchText.value.isEmpty {
            let recentlyItems = (1...10).map {
                SearchSectionItem.recentlyItem(movie: "Dummy \($0)") }
            let movieItems: [SearchSectionItem] = [
                .discoverPopular(movies: "Popular Movies"),
                .discoverTopRated(movies: "Top Rated Movies")
            ]
            let genreItems = genres.value.map { genre in
                SearchSectionItem.genres(kind: genre)
            }
            
            sections.accept([
                SearchSectionModel(title: SearchSectionKind.recentlyMovies.description, items: recentlyItems),
                SearchSectionModel(title: SearchSectionKind.discover.description, items: movieItems),
                SearchSectionModel(title: SearchSectionKind.genres.description, items: genreItems)
            ])
        } else {
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
    }
    
    private func searchMovies(searchText: String) {
        searchMovieUseCase.fetchSearchMovie(searchText: searchText)
            .asObservable()
            .map { movies in
                return movies.map { SearchSectionItem.searchMovies(movie: $0) }
            }
            .map { items in
                return [SearchSection(model: SearchSectionKind.movie.description, items: items)]
            }
            .bind(to: searchMovies)
            .disposed(by: disposeBag)
    }
    
    private func searchCollections(searchText: String) {
        searchMovieUseCase.fetchSearchCollection(searchText: searchText)
            .asObservable()
            .map { collections in
                return collections.map { SearchSectionItem.searchCollections(collection: $0) }
            }
            .map { items in
                return [SearchSection(model: SearchSectionKind.collection.description, items: items)]
            }
            .bind(to: searchCollections)
            .disposed(by: disposeBag)
    }
}
