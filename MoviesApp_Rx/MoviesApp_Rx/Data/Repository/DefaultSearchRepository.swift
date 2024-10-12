//
//  DefaultSearchRepository.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/20.
//

import Foundation
import RxSwift

final class DefaultSearchRepository: SearchRepository {
    let networkProvider: DefaultNetworkProvider
    
    init(networkProvider: DefaultNetworkProvider = DefaultNetworkProvider()) {
        self.networkProvider = networkProvider
    }
    
    func fetchDetailMovie(id: Int) -> Single<MovieDetail> {
        let request = MovieDetailEndpoint(id: id)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movie = response.toMovieDetail()
                return movie
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
    
    func fetchMoviesOfGenre(page: Int, id: Int) -> Single<MovieList> {
        let request = MovieDiscoveryEndpoint(page: page, id: id)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movieList = response.toMovieList()
                return movieList
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
    
    func fetchSearchMovie(searchText: String) -> Single<MovieList> {
        let request = SearchMovieEndpoint(searchText: searchText)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movieList = response.toMovieList()
                return movieList
            }
    }
    
    func fetchSearchCollection(searchText: String) -> Single<CollectionList> {
        let request = SearchCollectionEndpoint(searchText: searchText)
        return self.networkProvider.rx.request(request)
            .map { response in
                let collectionList = response.toCollectionList()
                return collectionList
            }
    }
    
    func fetchDetailCollection(id: Int) -> Single<DetailCollectionList> {
        let request = DetailCollectionEndpoint(id: id)
        return self.networkProvider.rx.request(request)
            .map { response in
                let detailCollectionList = response.toDetailCollectionList()
                return detailCollectionList
            }
    }
}
