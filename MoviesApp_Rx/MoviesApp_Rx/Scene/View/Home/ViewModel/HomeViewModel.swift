//
//  HomeViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/26.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct MovieSectionModel {
    var title: String
    var items: [Item]
}

extension MovieSectionModel: SectionModelType {
    typealias Item = Movie
    
    init(original: MovieSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

final class HomeViewModel {
    typealias MovieSection = SectionModel<String, Movie>
    
    var coordinator: HomeCoordinator?
    var page: Int = 1
    let upcomingMovies = BehaviorRelay<[MovieSectionModel]>(value: [])
    private let discoverUseCase: DiscoverUseCase
    private let disposebag = DisposeBag()
    
    init(discoverUseCase: DiscoverUseCase) {
        self.discoverUseCase = discoverUseCase
    }
    
    func fetchUpcomingMovies() {
            discoverUseCase.fetchUpcomingMovies(page: page)
                .asObservable()
                .map { [MovieSectionModel(title: "", items: $0)]}
                .bind(to: upcomingMovies)
                .disposed(by: disposebag)
    }
    
    func loadMoreUpcomingMovies() {
        page += 1
        discoverUseCase.fetchUpcomingMovies(page: page)
            .asObservable()
            .map { [MovieSectionModel(title: "", items: $0)]}
            .withLatestFrom(upcomingMovies) { newMovies, oldMovies in
                var allItems = oldMovies.first?.items ?? []
                allItems.append(contentsOf: newMovies.first?.items ?? [])
                return [MovieSectionModel(title: "", items: allItems)]
            }
            .bind(to: upcomingMovies)
            .disposed(by: disposebag)
    }
}
