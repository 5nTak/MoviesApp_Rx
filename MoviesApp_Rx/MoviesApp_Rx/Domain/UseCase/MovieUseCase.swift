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
    
    func fetchDiscoveryMovie(page: Int) -> Single<[Movie]> {
        return movieRepository.fetchDiscoveredMovies(page: page)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
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
    
    func fetchLatestMovie() -> Single<[Movie]> {
        return movieRepository.fetchLatestMovie()
            .map { movie in
                var movies: [Movie] = []
                movies.append(movie)
                return movies
            }
    }
    
    func fetchTrendingMovie() -> Single<[Movie]> {
        return movieRepository.fetchTrendingMovies()
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
}
