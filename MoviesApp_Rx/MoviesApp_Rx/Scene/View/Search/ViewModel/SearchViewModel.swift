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
    case recentlyItem(movie: MovieDetail)
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
    
    var searchText = BehaviorRelay<String>(value: "")
    var coordinator: SearchCoordinator?
    let sections = BehaviorRelay<[SearchSectionModel]>(value: [])
    let isDeleteMode = BehaviorRelay<Bool>(value: false)
    let selectedItems = BehaviorRelay<[Int]>(value: [])
    let genres = BehaviorRelay<[Genre]>(value: [])
    let isSearchActive = BehaviorRelay<Bool>(value: false)
    private let discoverUseCase: DiscoverUseCase
    private let movieInfoUseCase: MovieInfoUseCase
    private let genreUseCase: GenreUseCase
    private let searchUseCase: SearchUseCase
    private let recentlyManager = RecentlyViewedMoviesManager.shared
    private let disposeBag = DisposeBag()
    private let recentlyMovies = BehaviorRelay<[SearchSectionModel]>(value: [])
    private let searchMovies = BehaviorRelay<[SearchSection]>(value: [])
    private let searchCollections = BehaviorRelay<[SearchSection]>(value: [])
    
    init(
        discoverUseCase: DiscoverUseCase,
        movieInfoUseCase: MovieInfoUseCase,
        genreUseCase: GenreUseCase,
        searchUseCase: SearchUseCase
    ) {
        self.discoverUseCase = discoverUseCase
        self.movieInfoUseCase = movieInfoUseCase
        self.genreUseCase = genreUseCase
        self.searchUseCase = searchUseCase
        searchText
            .distinctUntilChanged()
            .subscribe { [weak self] text in
                self?.isSearchActive.accept(!text.isEmpty)
                self?.showSearchResult()
            }
            .disposed(by: disposeBag)
        recentlyManager.observeRecently()
        bindRecently()
        fetchGenre()
    }
    
    private func bindRecently() {
        recentlyManager.recentlyMovies
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movieIds in
                self?.checkRecentlyMovies(movieIds: movieIds)
            })
            .disposed(by: disposeBag)
    }
    
    private func checkRecentlyMovies(movieIds: [Int]) {
        var recentlyItems = [SearchSectionItem]()
        let fetchGroup = DispatchGroup()
        
        movieIds.forEach { id in
            fetchGroup.enter()
            searchUseCase.fetchDetailMovie(id: id)
                .asObservable()
                .subscribe(onNext: { movie in
                    recentlyItems.append(.recentlyItem(movie: movie))
                    fetchGroup.leave()
                }, onError: { _ in
                    fetchGroup.leave()
                })
                .disposed(by: disposeBag)
        }
        
        fetchGroup.notify(queue: .main) { [weak self] in
            let sectionModel = SearchSectionModel(
                title: SearchSectionKind.recentlyMovies.description,
                items: recentlyItems
            )
            self?.recentlyMovies.accept([sectionModel])
            self?.configureSections()
        }
    }
    
    func toggleDeleteMode() {
        isDeleteMode.accept(!isDeleteMode.value)
        if !isDeleteMode.value {
            selectedItems.accept([])
        }
    }
    
    func toggleSelection(movieId: Int) {
        var currentSelection = selectedItems.value
        if currentSelection.contains(movieId) {
            currentSelection.removeAll { $0 == movieId }
        } else {
            currentSelection.append(movieId)
        }
        selectedItems.accept(currentSelection)
    }
    
    func deleteSelectedMovies() {
        let movieIdsToDelete = selectedItems.value
        recentlyManager.deleteMovies(movieIds: movieIdsToDelete)
        toggleDeleteMode()
    }
    
    private func fetchGenre() {
        genreUseCase.fetchGenres()
            .asObservable()
            .bind(to: genres)
            .disposed(by: disposeBag)
    }
    
    func configureSections() {
        if searchText.value.isEmpty {
            createDefaultSections()
        } else {
            showSearchResult()
        }
    }
    
    func createDefaultSections() {
        let recentlyItems = recentlyMovies.value.flatMap { $0.items }
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
        searchUseCase.fetchSearchMovie(searchText: searchText)
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
        searchUseCase.fetchSearchCollection(searchText: searchText)
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
