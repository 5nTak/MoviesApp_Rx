//
//  MovieInfoUseCase.swift
//  MoviesApp_Rx
//
//  Created by Tak on 10/12/24.
//

import Foundation
import RxSwift

final class MovieInfoUseCase {
    private let homeRepository: HomeRepository
    private let accountRepository: AccountRepository
    
    init(homeRepository: HomeRepository, accountRepository: AccountRepository) {
        self.homeRepository = homeRepository
        self.accountRepository = accountRepository
    }
    
    func fetchDetailMovie(id: Int) -> Single<MovieDetail> {
        return self.homeRepository.fetchDetailMovie(id: id)
    }
    
    func fetchDetailMovies(id: Int) -> Single<MovieDetail> {
        return self.accountRepository.fetchDetailMovie(id: id)
    }
    
    func fetchReviews(id: Int) -> Single<[Review]> {
        return self.homeRepository.fetchReviews(id: id)
            .map { reviews in
                let reviewList = reviews.result
                return reviewList
            }
    }
    
    func fetchTrailer(id: Int) -> Single<[Video]> {
        return self.homeRepository.fetchTrailer(id: id)
            .map { trailer in
                let videos = trailer.results
                return videos
            }
    }
    
    func fetchCredits(id: Int) -> Single<Credit> {
        return self.homeRepository.fetchCredits(id: id)
    }
    
    func fetchSimilarMovies(id: Int, page: Int) -> Single<[Movie]> {
        return self.homeRepository.fetchSimilarMovies(id: id, page: page)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
    }
}
