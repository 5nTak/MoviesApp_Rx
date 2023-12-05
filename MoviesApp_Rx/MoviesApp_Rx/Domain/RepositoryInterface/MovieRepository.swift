//
//  MovieRepository.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/25.
//

import Foundation

protocol MovieRepository {
    func fetchMovieDiscovery(
        page: Int,
        completion: @escaping (Result<MovieList, Error>) -> Void
    ) -> URLSessionTask?
    
    func fetchPopularMovies(
        page: Int,
        completion: @escaping (Result<MovieList, Error>) -> Void
    ) -> URLSessionTask?
}
