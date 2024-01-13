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
    
    private var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        self.fetchData(for: movie)
    }
    
    var title: String = ""
    var posterPath: String?
    var overView: String = ""
    var releaseDate: String = ""
    var voteAverage: Double = 0.0
    var voteCount: Int = 0
    
    private func fetchData(for movie: Movie) {
        self.title = movie.title
        self.posterPath = movie.posterPath
        self.overView = movie.overview
        self.releaseDate = movie.releaseData
        self.voteAverage = self.roundVoteAveragePoint(primeNumber: movie.voteAverage)
        self.voteCount = movie.voteCount
    }
    
    private func roundVoteAveragePoint(primeNumber: Double) -> Double {
        let digit: Double = pow(10, 2)
        let voteAveraged = round(primeNumber * digit) / digit
        
        return voteAveraged
    }
}
