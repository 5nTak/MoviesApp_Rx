//
//  DefaultMovieRepository.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/25.
//

import Foundation

final class DefaultMovieRepository: MovieRepository {
    let networkProvider: DefaultNetworkProvider
    
    init(networkProvider: DefaultNetworkProvider = DefaultNetworkProvider()) {
        self.networkProvider = networkProvider
    }
    
    func fetchMovieDiscovery(page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> URLSessionTask? {
        let request = MovieDiscoveryEndpoint(page: page)
        return self.networkProvider.request(request) { result in
            switch result {
            case .success(let movieListResponses):
                completion(.success(movieListResponses.toMovieList()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> URLSessionTask? {
        let request = PopularMovieEndpoint(page: page)
        return self.networkProvider.request(request) { result in
            switch result {
            case .success(let movieListResponses):
                completion(.success(movieListResponses.toMovieList()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchLatestMovie(completion: @escaping (Result<Movie, Error>) -> Void) -> URLSessionTask? {
        let request = LatestMovieEndpoint()
        return self.networkProvider.request(request) { result in
            switch result {
            case .success(let movieResponse):
                completion(.success(movieResponse.toMovie()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTrendingMovies(completion: @escaping (Result<MovieList, Error>) -> Void) -> URLSessionTask? {
        let request = TrendingMovieEndpoint()
        return self.networkProvider.request(request) { result in
            switch result {
            case .success(let movieListResponses):
                completion(.success(movieListResponses.toMovieList()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
