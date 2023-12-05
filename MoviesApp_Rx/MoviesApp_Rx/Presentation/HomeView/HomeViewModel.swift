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
    var page: Int = 1
    private let movieUseCase: MovieUseCase
    var discoveredMoviesHandler: (([Movie]) -> Void)?
    
    init(movieUseCase: MovieUseCase = MovieUseCase()) {
        self.movieUseCase = movieUseCase
    }
    
    func bindMovies(closure: @escaping ([Movie]) -> Void) {
        self.moviesHandler = closure
    private func showMovieDiscovery() {
        movieUseCase.fetchMovieDiscovery(page: page) { result in
                self.discoveredMovies.append(contentsOf: movies)
    }
    
            switch result {
            case .success(let movies):
            case .failure(let error):
                print(error)
            }
        }
    }
}
