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
    
    func fetchSearchMovie(id: Int) -> Single<Movie> {
        let request = MovieEndpoint(id: id)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movie = response.toMovie()
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
    
    func fetchCredits(id: Int) -> Single<Credit> {
        let request = CreditEndpoint(id: id)
        return self.networkProvider.rx.request(request)
            .map { response in
                let credits = response.toCredit()
                return credits
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
