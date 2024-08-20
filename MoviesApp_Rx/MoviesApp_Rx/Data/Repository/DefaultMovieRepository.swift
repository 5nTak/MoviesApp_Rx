//
//  DefaultMovieRepositoryRx.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/17.
//

import Foundation
import RxSwift

final class DefaultMovieRepository: MovieRepository {
    let networkProvider: DefaultNetworkProvider
    
    init(networkProvider: DefaultNetworkProvider = DefaultNetworkProvider()) {
        self.networkProvider = networkProvider
    }
    
    func fetchUpcomingMovies(page: Int) -> Single<MovieList> {
        let request = UpcomingEndpoint(page: page)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movieList = response.toMovieList()
                return movieList
            }
    }
    
    func fetchDiscoveredMovies(page: Int) -> Single<MovieList> {
        let request = MovieDiscoveryEndpoint(page: page)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movieList = response.toMovieList()
                return movieList
            }
    }
    
    func fetchDiscoveredMovies(page: Int, id: Int) -> Single<MovieList> {
        let request = MovieDiscoveryEndpoint(page: page, id: id)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movieList = response.toMovieList()
                return movieList
            }
    }
    
    func fetchGenres() -> Single<[Genre]> {
        let request = GenreEndpoint()
        return self.networkProvider.rx.request(request)
            .map { response in
                let genres = response.toGenres()
                return genres
            }
    }
    
    func fetchPopularMovies(page: Int) -> Single<MovieList> {
        let request = PopularMovieEndpoint(page: page)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movieList = response.toMovieList()
                return movieList
            }
    }
    
    func fetchTopRatedMovies(page: Int) -> Single<MovieList> {
        let request = TopRatedMovieEndpoint(page: page)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movieList = response.toMovieList()
                return movieList
            }
    }
}
