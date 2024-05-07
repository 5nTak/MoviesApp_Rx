//
//  HomeViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/26.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct MovieSectionModel {
    var title: String
    var items: [Item]
}

extension MovieSectionModel: SectionModelType {
    typealias Item = Movie
    
    init(original: MovieSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

final class HomeViewModel {
    var coordinator: HomeCoordinator?
    
    typealias MovieSection = SectionModel<String, Movie>
    
    let sections = BehaviorRelay<[MovieSectionModel]>(value: [])
    private let discoveryMovie = BehaviorRelay<[MovieSection]>(value: [])
    private let popularMovie = BehaviorRelay<[MovieSection]>(value: [])
    private let trendingMovie = BehaviorRelay<[MovieSection]>(value: [])
    private let lateMovie = BehaviorRelay<[MovieSection]>(value: [])
    
    private var page: Int = 1
    private let movieUseCase: MovieUseCase
    private let disposebag = DisposeBag()
    
    init(movieUseCase: MovieUseCase) {
        self.movieUseCase = movieUseCase
    }
    
    func showMoviesRx() {
        showMovieDiscovery()
        showPopularMovie()
        showTrendingMovie()
        showLatestMovie()
        
        Observable.combineLatest(discoveryMovie, popularMovie, trendingMovie, lateMovie)
            .map { discovery, popular, trending, latest in
                let limitedPopularItems = popular.first?.items.prefix(5) ?? []
                return [
                    MovieSectionModel(title: MovieListSection.discover.description, items: discovery.first?.items ?? []),
                    MovieSectionModel(title: MovieListSection.popular.description, items: Array(limitedPopularItems)),
                    MovieSectionModel(title: MovieListSection.trending.description, items: trending.first?.items ?? []),
                    MovieSectionModel(title: MovieListSection.latest.description, items: latest.first?.items ?? [])
                ]
            }
            .bind(to: sections)
            .disposed(by: disposebag)
    }
    
    private func showMovieDiscovery() {
        movieUseCase.fetchDiscoveryMovie(page: page)
            .asObservable()
            .map { [MovieSection(model: MovieListSection.discover.description, items: $0)] }
            .bind(to: discoveryMovie)
            .disposed(by: disposebag)
    }

    private func showPopularMovie() {
        movieUseCase.fetchPopularMovie(page: page)
            .asObservable()
            .map { [MovieSection(model: MovieListSection.popular.description, items: $0)]}
            .bind(to: popularMovie)
            .disposed(by: disposebag)
    }

    private func showTrendingMovie() {
        movieUseCase.fetchTrendingMovie()
            .asObservable()
            .map { [MovieSection(model: MovieListSection.trending.description, items: $0)]}
            .bind(to: trendingMovie)
            .disposed(by: disposebag)
    }
    
    private func showLatestMovie() {
        movieUseCase.fetchLatestMovie()
            .asObservable()
            .map { [MovieSection(model: MovieListSection.latest.description, items: $0)]}
            .bind(to: lateMovie)
            .disposed(by: disposebag)
    }
}
