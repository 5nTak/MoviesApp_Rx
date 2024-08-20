//
//  MovieUseCase.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/17.
//

import Foundation
import RxSwift

final class MovieUseCase {
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func fetchUpcomingMovies(page: Int) -> Single<[Movie]> {
        return movieRepository.fetchUpcomingMovies(page: page)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
    
    func fetchDiscoveryMovie(page: Int) -> Single<[Movie]> {
        return movieRepository.fetchDiscoveredMovies(page: page)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
    
    func fetchDiscoveryMovie(page: Int, id: Int) -> Single<[Movie]> {
        return movieRepository.fetchDiscoveredMovies(page: page, id: id)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
    
    func fetchGenres() -> Single<[Genre]> {
        return movieRepository.fetchGenres()
    }
    
    func fetchPopularMovie(page: Int) -> Single<[Movie]> {
        return movieRepository.fetchPopularMovies(page: page)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
    
    func fetchTopRatedMovie(page: Int) -> Single<[Movie]> {
        return movieRepository.fetchTopRatedMovies(page: page)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
}
