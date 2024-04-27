//
//  HomeDetailViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import Foundation
import UIKit
import Kingfisher

final class DetailViewModel {
    weak var coordinator: DetailCoordinator?
    
    private var item: ItemData
    
    init(movie: Movie, title: String) {
        self.item = movie
        self.title = title
        self.fetchMovie(for: movie)
    }
    
    init(collection: Collection) {
        self.item = collection
        self.fetchCollection(for: collection)
    }
    
    var title: String?
    var posterPath: String?
    var overView: String = ""
    var releaseDate: String = ""
    var voteAverage: Double = 0.0
    var voteCount: Int = 0
    
    private func fetchMovie(for movie: Movie) {
        self.posterPath = movie.posterPath
        self.overView = movie.overview
        self.releaseDate = movie.releaseData
        self.voteAverage = self.roundVoteAveragePoint(primeNumber: movie.voteAverage)
        self.voteCount = movie.voteCount
    }
    
    private func fetchCollection(for collection: Collection) {
        self.title = collection.name
        self.posterPath = collection.posterPath
        self.overView = collection.overview
        self.releaseDate = "알 수 없음"
        self.voteAverage = 0.0
        self.voteCount = 0
    }
    
    private func roundVoteAveragePoint(primeNumber: Double) -> Double {
        let digit: Double = pow(10, 2)
        let voteAveraged = round(primeNumber * digit) / digit
        
        return voteAveraged
    }
}
