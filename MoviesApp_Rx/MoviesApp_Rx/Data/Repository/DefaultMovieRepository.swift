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
    
    func fetchMovieList(page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> URLSessionTask? {
        let request = MovieListEndpoint(page: page)
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
