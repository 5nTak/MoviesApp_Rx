//
//  DefaultHomeRepositoryRx.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/17.
//

import Foundation
import RxSwift

final class DefaultHomeRepository: HomeRepository {
    let networkProvider: DefaultNetworkProvider
    
    init(networkProvider: DefaultNetworkProvider = DefaultNetworkProvider()) {
        self.networkProvider = networkProvider
    }
    
    func fetchUpcomingMovies(page: Int) -> Single<MovieList> {
        let request = UpcomingEndpoint(page: page)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movieList = response.toMovieList()
                return movieList
            }
    }
    
    func fetchDetailMovie(id: Int) -> Single<MovieDetail> {
        let request = MovieDetailEndpoint(id: id)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movie = response.toMovieDetail()
                return movie
            }
    }
    
    func fetchGenres() -> Single<[Genre]> {
        let request = GenreEndpoint()
        return self.networkProvider.rx.request(request)
            .map { response in
                let genres = response.toGenres()
                return genres
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
}
