//
//  PopularCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/6/24.
//

import UIKit

final class PopularCoordinator: Coordinator, CoordinationFinishDelegate {
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
        let popularMoviesViewModel = PopularMoviesViewModel(
            useCase: MovieUseCase(
                movieRepository: DefaultMovieRepository(
                    networkProvider: DefaultNetworkProvider()
                )
            )
        )
        popularMoviesViewModel.coordinator = self
        let popularMoviesViewController = PopularMoviesViewController(viewModel: popularMoviesViewModel)
        self.navigationController?.pushViewController(popularMoviesViewController, animated: true)
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
