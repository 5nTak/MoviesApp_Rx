//
//  DefaultMovieRepositoryRx.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/17.
//

import Foundation
import RxSwift

final class DefaultMovieRepositoryRx: MovieRepositoryRx {
    let networkProvider: DefaultNetworkProvider
    
    init(networkProvider: DefaultNetworkProvider = DefaultNetworkProvider()) {
        self.networkProvider = networkProvider
    }
    
    func fetchDiscoveredMoviesRx(page: Int) -> Single<MovieList> {
        let request = MovieDiscoveryEndpoint(page: page)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movieList = response.toMovieList()
                return movieList
            }
    }
    
    func fetchPopularMoviesRx(page: Int) -> Single<MovieList> {
        let request = PopularMovieEndpoint(page: page)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movieList = response.toMovieList()
                return movieList
            }
    }
    
    func fetchLatestMovieRx() -> Single<Movie> {
        let request = LatestMovieEndpoint()
        return self.networkProvider.rx.request(request)
            .map { response in
                let movie = response.toMovie()
                return movie
            }
    }
    
    func fetchTrendingMoviesRx() -> Single<MovieList> {
        let request = TrendingMovieEndpoint()
        return self.networkProvider.rx.request(request)
            .map { response in
                let movieList = response.toMovieList()
                return movieList
            }
    }
}
