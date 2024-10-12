//
//  ReviewsViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ReviewsViewModel {
    let movieId: Int
    let movieName: String
    let reviews = BehaviorRelay<[Review]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    private let movieInfoUseCase: MovieInfoUseCase
    
    init(movieId: Int, movieName: String, movieInfoUseCase: MovieInfoUseCase) {
        self.movieId = movieId
        self.movieName = movieName
        self.movieInfoUseCase = movieInfoUseCase
        
        fetchReviews()
    }
    
    private func fetchReviews() {
        isLoading.accept(true)
        movieInfoUseCase.fetchReviews(id: movieId)
            .observe(on: MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { [weak self] fetchReviews in
                self?.isLoading.accept(false)
                self?.reviews.accept(fetchReviews)
            }, onError: { [weak self] error in
                print(error.localizedDescription)
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
