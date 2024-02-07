//
//  HomeViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/26.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewModel {
    weak var coordinator: HomeCoordinator?
    
    private let movieUseCaseRx: MovieUseCaseRx
    let discoveryMovie = BehaviorRelay<[MovieSection]>(value: [])
    let popularMovie = BehaviorRelay<[MovieSection]>(value: [])
    let lateMovie = BehaviorRelay<[MovieSection]>(value: [])
    let trendingMovie = BehaviorRelay<[MovieSection]>(value: [])
    
    let disposebag = DisposeBag()
    
    var page: Int = 1
    
    init(movieUseCaseRx: MovieUseCaseRx) {
        self.movieUseCaseRx = movieUseCaseRx
    }
    
    func showMoviesRx() {
        showMovieDiscoveryRx()
        showPopularMovieRx()
        showLatestMovieRx()
        showTrendingMovieRx()
    }
    
    private func showMovieDiscoveryRx() {
        movieUseCaseRx.fetchDiscoveryMovieRx(page: page)
            .asObservable()
            .bind(to: discoveryMovie)
            .disposed(by: disposebag)
    }
    
    private func showPopularMovieRx() {
        movieUseCaseRx.fetchPopularMovieRx(page: page)
            .asObservable()
            .bind(to: popularMovie)
            .disposed(by: disposebag)
    }
    
    private func showLatestMovieRx() {
        movieUseCaseRx.fetchLatestMovieRx()
            .asObservable()
            .bind(to: lateMovie)
            .disposed(by: disposebag)
    }
    
    private func showTrendingMovieRx() {
        movieUseCaseRx.fetchTrendingMovieRx()
            .asObservable()
            .bind(to: trendingMovie)
            .disposed(by: disposebag)
    }
}
