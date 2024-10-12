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
    case topPoster(movie: MovieDetail)
    case title(movie: MovieDetail)
    case explore(exploreItem: ExploreItem)
    case movieInfo(movie: MovieDetail)
    case movieOverview(movie: MovieDetail)
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
    
    var genres = BehaviorRelay<[Genre]>(value: [])
    let sections = BehaviorRelay<[DetailSectionModel]>(value: [])
    let exploreItems = BehaviorRelay<[ExploreItem]>(value: [.reviews, .trailers, .credits, .similarMovies])
    let isFavorite = BehaviorRelay<Bool>(value: false)
    weak var coordinator: DetailCoordinator?
    private let movieId: Int
    private let favoritesManager = FavoritesManager.shared()
    private let recentlyManager = RecentlyViewedMoviesManager.shared
    private let movieInfoUseCase: MovieInfoUseCase
    private let genreUseCase: GenreUseCase
    private let disposeBag = DisposeBag()
    
    init(movieId: Int, movieInfoUseCase: MovieInfoUseCase, genreUseCase: GenreUseCase) {
        self.movieId = movieId
        self.movieInfoUseCase = movieInfoUseCase
        self.genreUseCase = genreUseCase
        self.fetchMovieDetail()
        self.fetchGenres()
        
        recentlyManager.addRecentlyViewed(movieId: movieId)
        
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
    
    private func createSections(with movie: MovieDetail) {
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
        self.movieInfoUseCase.fetchDetailMovie(id: movieId)
            .asObservable()
            .subscribe(onNext: { movie in
                self.createSections(with: movie)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchGenres() {
        genreUseCase.fetchGenres()
            .asObservable()
            .subscribe(onNext: { genres in
                self.genres.accept(genres)
            })
            .disposed(by: disposeBag)
    }
    
    func matchGenreIds(ids: [Int]) -> [String] {
        let genreNames = ids.compactMap { id in
            return genres.value.first { $0.id == id }?.name
        }
        return genreNames
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
