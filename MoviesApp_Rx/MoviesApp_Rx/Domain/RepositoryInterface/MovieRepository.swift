//
//  MovieRepository.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/17.
//

import Foundation
import RxSwift

protocol MovieRepository {
    func fetchUpcomingMovies(page: Int) -> Single<MovieList>
    
    func fetchDiscoveredMovies(page: Int) -> Single<MovieList>
    
    func fetchDiscoveredMovies(page: Int, id: Int) -> Single<MovieList>
    
    func fetchGenres() -> Single<[Genre]>
    
    func fetchPopularMovies(page: Int) -> Single<MovieList>
    
    func fetchTopRatedMovies(page: Int) -> Single<MovieList>
}
