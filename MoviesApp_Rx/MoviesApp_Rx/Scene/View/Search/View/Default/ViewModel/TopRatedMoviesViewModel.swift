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
    private let useCase: MovieUseCase
    let topRatedMovies = BehaviorRelay<[Movie]>(value: [])
    private var genres = BehaviorRelay<[Genre]>(value: [])
    private let disposeBag = DisposeBag()
    private var isFetching: Bool = false
    
    init(useCase: MovieUseCase) {
        self.useCase = useCase
        self.fetchTopRatedMovies(page: page)
        fetchGenres()
    }
    
    private func fetchGenres() {
        useCase.fetchGenres()
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
            
            self.useCase.fetchTopRatedMovie(page: page)
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
