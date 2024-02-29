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
}
