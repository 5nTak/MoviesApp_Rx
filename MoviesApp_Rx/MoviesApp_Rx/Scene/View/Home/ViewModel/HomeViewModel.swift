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
    
    private let movieUseCase: MovieUseCase
    let discoveryMovie = BehaviorRelay<[MovieSection]>(value: [])
    let popularMovie = BehaviorRelay<[MovieSection]>(value: [])
    let lateMovie = BehaviorRelay<[MovieSection]>(value: [])
    let trendingMovie = BehaviorRelay<[MovieSection]>(value: [])
    
    let disposebag = DisposeBag()
    
    var page: Int = 1
    
    init(movieUseCase: MovieUseCase) {
        self.movieUseCase = movieUseCase
    }
    
    func showMoviesRx() {
        showMovieDiscovery()
        showPopularMovie()
        showLatestMovie()
        showTrendingMovie()
        
        Observable.combineLatest(discoveryMovie, popularMovie, lateMovie, trendingMovie)
            .map { discovery, popular, latest, trending in
                return [
                    MovieSectionModel(title: MovieListSection.discover.description, items: discovery.first?.items ?? []),
                    MovieSectionModel(title: MovieListSection.popular.description, items: popular.first?.items ?? []),
                    MovieSectionModel(title: MovieListSection.latest.description, items: latest.first?.items ?? []),
                    MovieSectionModel(title: MovieListSection.trending.description, items: trending.first?.items ?? [])
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

    private func showLatestMovie() {
        movieUseCase.fetchLatestMovie()
            .asObservable()
            .map { [MovieSection(model: MovieListSection.latest.description, items: $0)]}
            .bind(to: lateMovie)
            .disposed(by: disposebag)
    }

    private func showTrendingMovie() {
        movieUseCase.fetchTrendingMovie()
            .asObservable()
            .map { [MovieSection(model: MovieListSection.trending.description, items: $0)]}
            .bind(to: trendingMovie)
            .disposed(by: disposebag)
    }
}
