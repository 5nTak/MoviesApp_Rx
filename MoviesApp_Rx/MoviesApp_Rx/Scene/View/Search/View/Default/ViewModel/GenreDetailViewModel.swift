//
//  GenreDetailViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class GenreDetailViewModel {
    var coordinator: GenreCoordinator?
    var page: Int = 1
    let movies = BehaviorRelay<[Movie]>(value: [])
    let genreId: Int
    let genreName: String
    private var genres = BehaviorRelay<[Genre]>(value: [])
    private var isFetching: Bool = false
    private let disposeBag = DisposeBag()
    private let genreUseCase: GenreUseCase
    
    init(genreUseCase: GenreUseCase, id: Int, name: String) {
        self.genreUseCase = genreUseCase
        self.genreId = id
        self.genreName = name
        self.fetchMovies(page: page, id: id)
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
    
    func fetchMovies(page: Int, id: Int) {
        guard !isFetching else { return }
        isFetching = true
        
        self.genreUseCase.fetchMoviesOfGenre(page: page, id: id)
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] newMovies in
                guard let self = self else {
                    return
                }
                
                if !newMovies.isEmpty {
                    let currentMovies = self.movies.value
                    self.movies.accept(currentMovies + newMovies)
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
