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
    let discoveryMovie = PublishRelay<[Movie]>()
    let popularMovie = PublishRelay<[Movie]>()
    let lateMovie = PublishRelay<Movie>()
    let trendingMovie = PublishRelay<[Movie]>()
    
    let disposebag = DisposeBag()
    
    //MARK: - 기존 코드
//    var discoveredMovies: [Movie] = [] {
//        didSet {
//            discoveredMoviesHandler?(discoveredMovies)
//        }
//    }
//    var popularMovies: [Movie] = [] {
//        didSet {
//            popularMoviesHandler?(popularMovies)
//        }
//    }
//    var latestMovie: [Movie] = [] {
//        didSet {
//            latestMovieHandler?(latestMovie)
//        }
//    }
//    var trendingMovies: [Movie] = [] {
//        didSet {
//            trendingMoviesHandler?(trendingMovies)
//        }
//    }
    var page: Int = 1
    
//    private let movieUseCase: MovieUseCase
//    var discoveredMoviesHandler: (([Movie]) -> Void)?
//    var popularMoviesHandler: (([Movie]) -> Void)?
//    var latestMovieHandler: (([Movie]) -> Void)?
//    var trendingMoviesHandler: (([Movie]) -> Void)?
//
    init(movieUseCaseRx: MovieUseCaseRx) {
        self.movieUseCaseRx = movieUseCaseRx
    }
    
//    func showContents() {
//        showMovieDiscovery()
//        showPopularMovies()
//        showLatestMovie()
//        showTrendingMovies()
//    }
    
//    private func showMovieDiscovery() {
//        movieUseCase.fetchMovieDiscovery(page: page) { result in
//            switch result {
//            case .success(let movies):
//                self.discoveredMovies.append(contentsOf: movies)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//    private func showPopularMovies() {
//        movieUseCase.fetchPopularMoviesPage(page: page) { result in
//            switch result {
//            case .success(let movies):
//                self.popularMovies.append(contentsOf: movies)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//    private func showLatestMovie() {
//        movieUseCase.fetchLatestMovie { result in
//            switch result {
//            case .success(let movie):
//                self.latestMovie.append(movie)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//    private func showTrendingMovies() {
//        movieUseCase.fetchTrendingMoviesPage { result in
//            switch result {
//            case .success(let movies):
//                self.trendingMovies.append(contentsOf: movies)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    // MARK: - RxSwift
    
    // Single을 asObservable화해서 옵저버블은 그냥 relay 등등 bind해주면 넘어간다
    // accept는 relay의 onNext
    // map은 내부 타입 변경
    // flatmap은 옵저버블의 타입 변경 .. 아마도? observable을 반환해야함!
    
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
