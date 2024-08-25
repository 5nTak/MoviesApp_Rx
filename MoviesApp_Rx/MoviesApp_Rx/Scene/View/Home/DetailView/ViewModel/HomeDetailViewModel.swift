//
//  HomeDetailViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import FirebaseAuth

enum DetailSectionItem {
    case topPoster(movie: Movie)
    case title(movie: Movie)
    case explore(exploreItem: ExploreItem)
    case movieInfo(movie: Movie)
    case movieOverview(movie: Movie)
}

enum ExploreItem {
    case reviews
    case trailers
    case credits
    case similarMovies
}

struct DetailSectionModel {
    var title: String
    var items: [DetailSectionItem]
}

extension DetailSectionModel: SectionModelType {
    typealias Item = DetailSectionItem
    
    init(original: DetailSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

final class DetailViewModel {
    typealias DetailSection = SectionModel<String, DetailSectionItem>
    
    weak var coordinator: DetailCoordinator?
    let sections = BehaviorRelay<[DetailSectionModel]>(value: [])
    let exploreItems = BehaviorRelay<[ExploreItem]>(value: [.reviews, .trailers, .credits, .similarMovies])
    
    private let movieId: Int
    private let favoritesManager = FavoritesManager.shared()
    private let useCase: SearchUseCase
    private let disposeBag = DisposeBag()
    
    let isFavorite = BehaviorRelay<Bool>(value: false)
    
    init(movieId: Int, useCase: SearchUseCase) {
        self.movieId = movieId
        self.useCase = useCase
        self.fetchMovieDetail()
        
        if Auth.auth().currentUser != nil {
            favoritesManager.isFavoriteMovie(movieId: movieId)
                .subscribe(onSuccess: { [weak self] isFavorite in
                    self?.isFavorite.accept(isFavorite)
                }, onFailure: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func createSections(with movie: Movie) {
        let topPosterItem = DetailSectionItem.topPoster(movie: movie)
        let topPosterSection = DetailSectionModel(title: "Top Poster", items: [topPosterItem])
        
        let titleItem = DetailSectionItem.title(movie: movie)
        let titleSection = DetailSectionModel(title: "Title", items: [titleItem])
        
        let exploreItems = exploreItems.value.map { DetailSectionItem.explore(exploreItem: $0) }
        let exploreSection = DetailSectionModel(title: "Explore", items: exploreItems)
        
        let movieInfoItem = DetailSectionItem.movieInfo(movie: movie)
        let movieInfoSection = DetailSectionModel(title: "Movie Info", items: [movieInfoItem])
        
        let movieOverviewItem = DetailSectionItem.movieOverview(movie: movie)
        let movieOverviewSection = DetailSectionModel(title: "Overview", items: [movieOverviewItem])

        sections.accept([topPosterSection, titleSection, exploreSection, movieInfoSection, movieOverviewSection])
    }
    
    private func fetchMovieDetail() {
        self.useCase.fetchSearchMovie(id: movieId)
            .asObservable()
            .subscribe(onNext: { movie in
                self.createSections(with: movie)
            })
            .disposed(by: disposeBag)
    }
    
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
