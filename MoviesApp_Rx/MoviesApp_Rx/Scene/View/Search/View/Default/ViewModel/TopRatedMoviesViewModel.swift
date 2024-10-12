//
//  TopRatedMoviesViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class TopRatedMoviesViewModel {
    var coordinator: TopRatedCoordinator?
    var page: Int = 1
    let topRatedMovies = BehaviorRelay<[Movie]>(value: [])
    private var genres = BehaviorRelay<[Genre]>(value: [])
    private var isFetching: Bool = false
    private let disposeBag = DisposeBag()
    private let discoverUseCase: DiscoverUseCase
    private let genreUseCase: GenreUseCase
    
    init(discoverUseCase: DiscoverUseCase, genreUseCase: GenreUseCase) {
        self.discoverUseCase = discoverUseCase
        self.genreUseCase = genreUseCase
        self.fetchTopRatedMovies(page: page)
        fetchGenres()
    }
    
    private func fetchGenres() {
        genreUseCase.fetchGenres()
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: genres)
            .disposed(by: disposeBag)
    }
    
    func matchGenreIds(ids: [Int]) -> [String] {
        let genreNames = ids.compactMap { id in
            return genres.value.first { $0.id == id }?.name
        }
        return genreNames
    }
    
    func fetchTopRatedMovies(page: Int) {
            guard !isFetching else { return }
            isFetching = true
            
            self.discoverUseCase.fetchTopRatedMovie(page: page)
            .asObservable()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] newMovies in
                    guard let self = self else { return }
                    
                    if !newMovies.isEmpty {
                        let currentMovies = self.topRatedMovies.value
                        self.topRatedMovies.accept(currentMovies + newMovies)
                        self.page += 1
                    }
                    
                    self.isFetching = false
                }, onError: { [weak self] error in
                    self?.isFetching = false
                    print("Error fetching movies: \(error)")
                })
                .disposed(by: disposeBag)
        }
}
