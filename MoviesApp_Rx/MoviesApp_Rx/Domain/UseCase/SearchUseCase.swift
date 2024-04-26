//
//  SearchUseCase.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/20.
//

import Foundation
import RxSwift

final class SearchUseCase {
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func fetchSearchMovie(searchText: String) -> Single<[Movie]> {
        return self.searchRepository.fetchSearchMovie(searchText: searchText)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
    
    func fetchSearchCollection(searchText: String) -> Single<[Collection]> {
        return self.searchRepository.fetchSearchCollection(searchText: searchText)
            .map { collectionList in
                let collections = collectionList.results
                return collections
            }
    }
    
    func fetchDetailCollection(id: Int) -> Single<[DetailCollection]> {
        return self.searchRepository.fetchDetailCollection(id: id)
            .map { detailCollectionList in
                let detailCollections = detailCollectionList.parts
                return detailCollections
            }
    }
}
