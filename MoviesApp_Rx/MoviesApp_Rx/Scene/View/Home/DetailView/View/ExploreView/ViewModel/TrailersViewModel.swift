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
    let movieId: Int
    let movieName: String
    let videos = BehaviorRelay<[Video]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    private let movieInfoUseCase: MovieInfoUseCase
    
    init(movieId: Int, movieName: String, movieInfoUseCase: MovieInfoUseCase) {
        self.movieId = movieId
        self.movieName = movieName
        self.movieInfoUseCase = movieInfoUseCase
        
        fetchVideos()
    }
    
    private func fetchVideos() {
        isLoading.accept(true)
        movieInfoUseCase.fetchTrailer(id: movieId)
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
