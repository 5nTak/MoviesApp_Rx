//
//  DiscoverUseCase.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/17.
//

import Foundation
import RxSwift

final class DiscoverUseCase {
    private let homeRepository: HomeRepository
    private let searchRepository: SearchRepository
    
    init(homeRepository: HomeRepository, searchRepository: SearchRepository) {
        self.homeRepository = homeRepository
        self.searchRepository = searchRepository
    }
    
    func fetchUpcomingMovies(page: Int) -> Single<[Movie]> {
        return homeRepository.fetchUpcomingMovies(page: page)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
    
    func fetchPopularMovie(page: Int) -> Single<[Movie]> {
        return searchRepository.fetchPopularMovies(page: page)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
    
    func fetchTopRatedMovie(page: Int) -> Single<[Movie]> {
        return searchRepository.fetchTopRatedMovies(page: page)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
}
