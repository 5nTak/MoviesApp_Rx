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
    
    func fetchMovieDiscovery(
        page: Int,
        completion: @escaping (Result<[Movie], Error>) -> Void
    ) {
        self.fetchMovieDiscoveryPage(page: page) { result in
            switch result {
            case .success(let movieList):
                completion(.success(movieList.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    private func fetchMovieDiscoveryPage(
        page: Int,
        completion: @escaping (Result<MovieList, Error>) -> Void
    ) -> URLSessionTask? {
        return movieRepository.fetchMovieDiscovery(page: page, completion: completion)
    }
    
    func fetchPopularMoviesPage(
        page: Int,
        completion: @escaping (Result<[Movie], Error>) -> Void
    ) {
        self.fetchPopularMovies(page: page) { result in
            switch result {
            case .success(let movieList):
                completion(.success(movieList.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    private func fetchPopularMovies(
        page: Int,
        completion: @escaping (Result<MovieList, Error>) -> Void
    ) -> URLSessionTask? {
        return movieRepository.fetchPopularMovies(page: page, completion: completion)
    }
    
    func fetchLatestMovie(
        completion: @escaping (Result<Movie, Error>) -> Void
    ) -> URLSessionTask? {
        return movieRepository.fetchLatestMovie(completion: completion)
    }
    
    func fetchTrendingMoviesPage(
        completion: @escaping (Result<[Movie], Error>) -> Void
    ) {
        self.fetchTrendingMovies { result in
            switch result {
            case .success(let movieList):
                completion(.success(movieList.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    private func fetchTrendingMovies(
        completion: @escaping (Result<MovieList, Error>) -> Void
    ) -> URLSessionTask? {
        return movieRepository.fetchTrendingMovies(completion: completion)
    }
}
