//
//  PopularMoviesViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PopularMoviesViewModel {
    var coordinator: PopularCoordinator?
    var page: Int = 1
    private let useCase: MovieUseCase
    let popularMovies = BehaviorRelay<[Movie]>(value: [])
    private let disposeBag = DisposeBag()
    private var isFetching: Bool = false
    
    init(useCase: MovieUseCase) {
        self.useCase = useCase
        self.fetchPopularMovies(page: page)
    }
    
    func fetchPopularMovies(page: Int) {
            guard !isFetching else { return }
            isFetching = true
            
            self.useCase.fetchPopularMovie(page: page)
            .asObservable()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] newMovies in
                    guard let self = self else { return }
                    
                    if !newMovies.isEmpty {
                        let currentMovies = self.popularMovies.value
                        self.popularMovies.accept(currentMovies + newMovies)
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
