//
//  TrailersViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 9/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class TrailersViewModel {
    private let disposeBag = DisposeBag()
    private let useCase: SearchUseCase
    
    let movieId: Int
    let movieName: String
    
    let videos = BehaviorRelay<[Video]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    init(movieId: Int, movieName: String, useCase: SearchUseCase) {
        self.movieId = movieId
        self.movieName = movieName
        self.useCase = useCase
        
        fetchVideos()
    }
    
    private func fetchVideos() {
        isLoading.accept(true)
        useCase.fetchTrailer(id: movieId)
            .observe(on: MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { [weak self] videos in
                self?.isLoading.accept(false)
                self?.videos.accept(videos)
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
