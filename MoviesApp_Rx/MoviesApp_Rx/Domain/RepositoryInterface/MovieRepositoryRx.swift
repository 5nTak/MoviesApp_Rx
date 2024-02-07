//
//  MovieRepositoryRx.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/17.
//

import Foundation
import RxSwift

protocol MovieRepositoryRx {
    func fetchDiscoveredMoviesRx(page: Int) -> Single<MovieList>
    
    func fetchPopularMoviesRx(page: Int) -> Single<MovieList>
    
    func fetchLatestMovieRx() -> Single<Movie>
    
    func fetchTrendingMoviesRx() -> Single<MovieList>
}
