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
    var latestMovie: [Movie] = [] {
        didSet {
            latestMovieHandler?(latestMovie)
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
    var latestMovieHandler: (([Movie]) -> Void)?
    var trendingMoviesHandler: (([Movie]) -> Void)?
    
    init(movieUseCase: MovieUseCase = MovieUseCase()) {
        self.movieUseCase = movieUseCase
    }
    
    func showContents() {
        showMovieDiscovery()
        showPopularMovies()
        showLatestMovie()
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
    
    private func showLatestMovie() {
        movieUseCase.fetchLatestMovie { result in
            switch result {
            case .success(let movie):
                self.latestMovie.append(movie)
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
