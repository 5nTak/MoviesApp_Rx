//
//  TopRatedCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/11/24.
//

import UIKit

final class TopRatedCoordinator: Coordinator, CoordinationFinishDelegate {
    var childCoordinator: [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate?
    var navigationController: UINavigationController?
    var identifier = UUID()
    
    init(
        navigationController: UINavigationController?,
        finishDelegate: CoordinationFinishDelegate
    ) {
        self.navigationController = navigationController
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let topRatedMoviesViewModel = TopRatedMoviesViewModel(
            discoverUseCase: DiscoverUseCase(
                homeRepository: DefaultHomeRepository(),
                searchRepository: DefaultSearchRepository()
            ),
            genreUseCase: GenreUseCase(
                searchRepository: DefaultSearchRepository()
            )
        )
        topRatedMoviesViewModel.coordinator = self
        let topRatedMoviesViewController = TopRatedMoviesViewController(viewModel: topRatedMoviesViewModel)
        self.navigationController?.pushViewController(topRatedMoviesViewController, animated: true)
    }
    
    func detailFlow(title: String, movieId: Int) {
        let detailCoordinator = DetailCoordinator(
            movieId: movieId,
            movieName: title,
            navigationController: self.navigationController,
            finishDelegate: self)
        self.childCoordinator.append(detailCoordinator)
        detailCoordinator.start()
    }
}
