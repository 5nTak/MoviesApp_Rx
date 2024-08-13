//
//  MovieRepository.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/17.
//

import Foundation
import RxSwift

protocol MovieRepository {
    func fetchDiscoveredMovies(page: Int) -> Single<MovieList>
    
    func fetchPopularMovies(page: Int) -> Single<MovieList>
    
    func fetchTopRatedMovies(page: Int) -> Single<MovieList>
    
    func fetchLatestMovie() -> Single<Movie>
    
    func fetchTrendingMovies() -> Single<MovieList>
}
