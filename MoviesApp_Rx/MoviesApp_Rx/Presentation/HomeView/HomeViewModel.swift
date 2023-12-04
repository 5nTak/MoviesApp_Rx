//
//  HomeViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/26.
//

import UIKit

final class HomeViewModel {
    var movies: [Movie] = [] {
        didSet {
            moviesHandler?(movies)
        }
    }
    var page: Int = 1
    private let movieUseCase: MovieUseCase
    var moviesHandler: (([Movie]) -> Void)?
    
    init(movieUseCase: MovieUseCase = MovieUseCase()) {
        self.movieUseCase = movieUseCase
    }
    
    func bindMovies(closure: @escaping ([Movie]) -> Void) {
        self.moviesHandler = closure
    }
    
    func showMovies() {
        movieUseCase.fetchMovies(page: page) { result in
            switch result {
            case .success(let movies):
                self.movies.append(contentsOf: movies)
            case .failure(let error):
                print(error)
            }
        }
    }
}
