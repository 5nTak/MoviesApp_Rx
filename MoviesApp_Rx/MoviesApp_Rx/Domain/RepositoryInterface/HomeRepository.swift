//
//  HomeRepository.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/17.
//

import Foundation
import RxSwift

protocol HomeRepository {
    func fetchUpcomingMovies(page: Int) -> Single<MovieList>
    
    func fetchDetailMovie(id: Int) -> Single<MovieDetail>
    
    func fetchGenres() -> Single<[Genre]>
    
    func fetchReviews(id: Int) -> Single<Reviews>
    
    func fetchTrailer(id: Int) -> Single<Trailer>
    
    func fetchCredits(id: Int) -> Single<Credit>
    
    func fetchSimilarMovies(id: Int, page: Int) -> Single<MovieList>
}
