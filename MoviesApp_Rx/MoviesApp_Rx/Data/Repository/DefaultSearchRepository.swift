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
    
    func fetchSearchMovie(id: Int) -> Single<MovieDetail> {
        let request = MovieDetailEndpoint(id: id)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movie = response.toMovieDetail()
                return movie
            }
    }
    
    func fetchReviews(id: Int) -> Single<Reviews> {
        let request = ReviewsEndpoint(id: id)
        return self.networkProvider.rx.request(request)
            .map { response in
                let reviews = response.toReviews()
                return reviews
            }
    }
    
    func fetchTrailer(id: Int) -> Single<Trailer> {
        let request = TrailersEndpoint(id: id)
        return self.networkProvider.rx.request(request)
            .map { response in
                let trailers = response.toTrailer()
                return trailers
            }
    }
    
    func fetchCredits(id: Int) -> Single<Credit> {
        let request = CreditEndpoint(id: id)
        return self.networkProvider.rx.request(request)
            .map { response in
                let credits = response.toCredit()
                return credits
            }
    }
    
    func fetchSimilarMovies(id: Int, page: Int) -> Single<MovieList> {
        let request = SimilarEndpoint(id: id, page: page)
        return self.networkProvider.rx.request(request)
            .map { response in
                let similarMovies = response.toMovieList()
                return similarMovies
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
