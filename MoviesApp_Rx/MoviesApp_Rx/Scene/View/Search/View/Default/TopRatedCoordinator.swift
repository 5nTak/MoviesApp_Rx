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
            useCase: MovieUseCase(
                movieRepository: DefaultMovieRepository(
                    networkProvider: DefaultNetworkProvider()
                )
            )
        )
        topRatedMoviesViewModel.coordinator = self
        let topRatedMoviesViewController = TopRatedMoviesViewController(viewModel: topRatedMoviesViewModel)
        self.navigationController?.pushViewController(topRatedMoviesViewController, animated: true)
    }
    
    func detailFlow(with movie: Movie, title: String, movieId: Int) {
        let detailCoordinator = DetailCoordinator(
            movie: movie,
            title: title,
            movieId: movieId,
            navigationController: self.navigationController,
            finishDelegate: self)
        self.childCoordinator.append(detailCoordinator)
        detailCoordinator.start()
    }
}
