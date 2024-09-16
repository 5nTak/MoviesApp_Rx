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
    
    func fetchSearchMovie(id: Int) -> Single<MovieDetail> {
        return self.searchRepository.fetchSearchMovie(id: id)
    }
    
    func fetchReviews(id: Int) -> Single<[Review]> {
        return self.searchRepository.fetchReviews(id: id)
            .map { reviews in
                let reviewList = reviews.result
                return reviewList
            }
    }
    
    func fetchTrailer(id: Int) -> Single<[Video]> {
        return self.searchRepository.fetchTrailer(id: id)
            .map { trailer in
                let videos = trailer.results
                return videos
            }
    }
    
    func fetchCredits(id: Int) -> Single<Credit> {
        return self.searchRepository.fetchCredits(id: id)
    }
    
    func fetchSimilarMovies(id: Int, page: Int) -> Single<[Movie]> {
        return self.searchRepository.fetchSimilarMovies(id: id, page: page)
            .map { movieList in
                let movies = movieList.results
                return movies
            }
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
