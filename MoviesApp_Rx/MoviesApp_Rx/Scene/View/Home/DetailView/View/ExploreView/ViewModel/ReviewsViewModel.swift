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
    private let disposeBag = DisposeBag()
    private let useCase: SearchUseCase
    
    let movieId: Int
    let movieName: String
    
    let reviews = BehaviorRelay<[Review]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    init(movieId: Int, movieName: String, useCase: SearchUseCase) {
        self.movieId = movieId
        self.movieName = movieName
        self.useCase = useCase
        
        fetchReviews()
    }
    
    private func fetchReviews() {
        isLoading.accept(true)
        useCase.fetchReviews(id: movieId)
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
