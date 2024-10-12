//
//  SimilarMoviesViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SimilarMoviesViewModel {
    var movieId: Int
    var page: Int = 1
    let isLoading = BehaviorRelay<Bool>(value: false)
    let similarMovies = BehaviorRelay<[Movie]>(value: [])
    weak var coordinator: SimilarCoordinator?
    private let movieUseCase: DiscoverUseCase
    private let searchUseCase: SearchUseCase
    private let disposeBag = DisposeBag()
    private var isFetching: Bool = false
    private let genres = BehaviorRelay<[Genre]>(value: [])
    
    init(movieId: Int, movieUseCase: DiscoverUseCase, searchUseCase: SearchUseCase) {
        self.movieId = movieId
        self.movieUseCase = movieUseCase
        self.searchUseCase = searchUseCase
        
        fetchGenres()
        fetchSimilarMovies(id: movieId, page: page)
    }
    
    private func fetchGenres() {
        self.movieUseCase.fetchGenres()
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
    
    func fetchSimilarMovies(id: Int, page: Int) {
        guard !isFetching else { return }
        isFetching = true
        
        isLoading.accept(true)
        
        self.searchUseCase.fetchSimilarMovies(id: id, page: page)
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] newMovies in
                guard let self = self else {
                    return
                }
                self.isLoading.accept(false)
                if !newMovies.isEmpty {
                    let currentMovies = self.similarMovies.value
                    self.similarMovies.accept(currentMovies + newMovies)
                    self.page += 1
                }
                
                self.isFetching = false
            }, onError: { [weak self] error in
                self?.isFetching = false
                self?.isLoading.accept(false)
                print("Error fetching movies: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
