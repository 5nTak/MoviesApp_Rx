//
//  HomeDetailViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

final class DetailViewModel {
    weak var coordinator: DetailCoordinator?
    
    private var movie: Movie
    
    var title: String?
    var posterPath: String?
    var overView: String = ""
    var releaseDate: String = ""
    var voteAverage: Double = 0.0
    var voteCount: Int = 0
    
    private let movieId: Int
    private let favoritesManager = FavoritesManager.shared()
    private let disposeBag = DisposeBag()
    
    let isFavorite = BehaviorRelay<Bool>(value: false)
    
    init(movie: Movie, title: String, movieId: Int) {
        self.movie = movie
        self.title = title
        self.movieId = movieId
        self.fetchMovie(for: movie)
        favoritesManager.isFavoriteMovie(movieId: movieId)
            .subscribe(onSuccess: { [weak self] isFavorite in
                self?.isFavorite.accept(isFavorite)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchMovie(for movie: Movie) {
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
    
//    func toggleFavorite() {
//        if isFavorite.value {
//            favoritesManager.removeFavoriteMovie(movieId: movieId)
//            isFavorite.accept(false)
//        } else {
//            favoritesManager.addFavoriteMovie(movieId: movieId)
//            isFavorite.accept(true)
//        }
//    }
    
//    private func checkIfFavorite() {
//        guard let movie = item as? Movie else { return }
//        
//        favoritesManager.isFavoriteMovie(movieId: movie.id)
//            .subscribe(onSuccess: { [weak self] isFavorite in
//                self?.isFavorite.accept(isFavorite)
//            })
//            .disposed(by: disposeBag)
//    }
    
    func toggleFavorite() {
        let isCurrentlyFavorite = isFavorite.value
        let action: Completable
        
        if isCurrentlyFavorite {
            action = favoritesManager.removeFavoriteMovie(movieId: movieId)
        } else {
            action = favoritesManager.addFavoriteMovie(movieId: movieId)
        }
        
        action.subscribe(onCompleted: { [weak self] in
            self?.isFavorite.accept(!isCurrentlyFavorite)
        }, onError: { error in
            print("Failed to toggle favorite: \(error)")
        }).disposed(by: disposeBag)
    }
}
