//
//  GenreUseCase.swift
//  MoviesApp_Rx
//
//  Created by Tak on 10/12/24.
//

import Foundation
import RxSwift

final class GenreUseCase {
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func fetchGenres() -> Single<[Genre]> {
        return searchRepository.fetchGenres()
    }
    
    func fetchMoviesOfGenre(page: Int, id: Int) -> Single<[Movie]> {
        return searchRepository.fetchMoviesOfGenre(page: page, id: id)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
}
