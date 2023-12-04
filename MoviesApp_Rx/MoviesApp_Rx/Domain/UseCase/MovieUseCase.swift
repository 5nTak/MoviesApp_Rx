//
//  MovieUseCase.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/25.
//

import Foundation

final class MovieUseCase {
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository = DefaultMovieRepository()) {
        self.movieRepository = movieRepository
    }
    
    func fetchMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        self.fetchMovieList(page: page) { result in
            switch result {
            case .success(let movieList):
                completion(.success(movieList.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchMovieList(
        page: Int,
        completion: @escaping (Result<MovieList, Error>) -> Void
    ) -> URLSessionTask? {
        return movieRepository.fetchMovieList(page: page, completion: completion)
    }
}
