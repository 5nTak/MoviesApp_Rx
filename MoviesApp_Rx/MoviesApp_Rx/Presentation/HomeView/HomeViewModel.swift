//
//  HomeViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/26.
//

import UIKit

final class HomeViewModel {
    var discoveredMovies: [Movie] = [] {
        didSet {
            discoveredMoviesHandler?(discoveredMovies)
        }
    }
    var popularMovies: [Movie] = [] {
        didSet {
            popularMoviesHandler?(popularMovies)
        }
    }
    var trendingMovies: [Movie] = [] {
        didSet {
            trendingMoviesHandler?(trendingMovies)
        }
    }
    var page: Int = 1
    private let movieUseCase: MovieUseCase
    var discoveredMoviesHandler: (([Movie]) -> Void)?
    var popularMoviesHandler: (([Movie]) -> Void)?
    var trendingMoviesHandler: (([Movie]) -> Void)?
    
    init(movieUseCase: MovieUseCase = MovieUseCase()) {
        self.movieUseCase = movieUseCase
    }
    
    func bindMovies(closure: @escaping ([Movie]) -> Void) {
        self.discoveredMoviesHandler = closure
        self.popularMoviesHandler = closure
        self.trendingMoviesHandler = closure
    }
    
    func showContents() {
        showMovieDiscovery()
        showPopularMovies()
        showTrendingMovies()
    }
    
    private func showMovieDiscovery() {
        movieUseCase.fetchMovieDiscovery(page: page) { result in
            switch result {
            case .success(let movies):
                self.discoveredMovies.append(contentsOf: movies)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func showPopularMovies() {
        movieUseCase.fetchPopularMoviesPage(page: page) { result in
            switch result {
            case .success(let movies):
                self.popularMovies.append(contentsOf: movies)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func showTrendingMovies() {
        movieUseCase.fetchTrendingMoviesPage { result in
            switch result {
            case .success(let movies):
                self.trendingMovies.append(contentsOf: movies)
            case .failure(let error):
                print(error)
            }
        }
    }
}
