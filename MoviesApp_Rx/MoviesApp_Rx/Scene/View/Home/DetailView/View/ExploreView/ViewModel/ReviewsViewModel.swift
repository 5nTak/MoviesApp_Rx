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
    
    init(movieId: Int, movieName: String, useCase: SearchUseCase) {
        self.movieId = movieId
        self.movieName = movieName
        self.useCase = useCase
        
        fetchReviews()
    }
    
    private func fetchReviews() {
        useCase.fetchReviews(id: movieId)
            .asObservable()
            .subscribe(onNext: { [weak self] fetchReviews in
                self?.reviews.accept(fetchReviews)
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
