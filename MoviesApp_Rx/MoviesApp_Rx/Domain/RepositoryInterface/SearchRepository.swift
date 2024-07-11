//
//  SearchRepository.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/20.
//

import Foundation
import RxSwift

protocol SearchRepository {
    func fetchSearchMovie(id: Int) -> Single<Movie>
    
    func fetchSearchMovie(searchText: String) -> Single<MovieList>
    
    func fetchSearchCollection(searchText: String) -> Single<CollectionList>
    
    func fetchDetailCollection(id: Int) -> Single<DetailCollectionList>
}
