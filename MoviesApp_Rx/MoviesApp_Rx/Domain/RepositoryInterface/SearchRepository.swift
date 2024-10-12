//
//  SearchRepository.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/20.
//

import Foundation
import RxSwift

protocol SearchRepository {
    func fetchDetailMovie(id: Int) -> Single<MovieDetail>
    
    func fetchGenres() -> Single<[Genre]>
    
    func fetchMoviesOfGenre(page: Int, id: Int) -> Single<MovieList>
    
    func fetchPopularMovies(page: Int) -> Single<MovieList>
    
    func fetchTopRatedMovies(page: Int) -> Single<MovieList>
    
    func fetchSearchMovie(searchText: String) -> Single<MovieList>
    
    func fetchSearchCollection(searchText: String) -> Single<CollectionList>
    
    func fetchDetailCollection(id: Int) -> Single<DetailCollectionList>
}
