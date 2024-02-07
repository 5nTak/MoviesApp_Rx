//
//  MovieUseCaseRx.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/17.
//

import Foundation
import RxSwift

final class MovieUseCaseRx {
    private let movieRepositoryRx: MovieRepositoryRx
    
    init(movieRepositoryRx: MovieRepositoryRx) {
        self.movieRepositoryRx = movieRepositoryRx
    }
    
    func fetchDiscoveryMovieRx(page: Int) -> Single<[Movie]> {
        return movieRepositoryRx.fetchDiscoveredMoviesRx(page: page)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
    
    func fetchPopularMovieRx(page: Int) -> Single<[Movie]> {
        return movieRepositoryRx.fetchPopularMoviesRx(page: page)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
    
    func fetchLatestMovieRx() -> Single<[Movie]> {
        return movieRepositoryRx.fetchLatestMovieRx()
            .map { movie in
                var movies: [Movie] = []
                movies.append(movie)
                return movies
            }
    }
    
    func fetchTrendingMovieRx() -> Single<[Movie]> {
        return movieRepositoryRx.fetchTrendingMoviesRx()
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
}
