//
//  SimilarCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/28/24.
//

import UIKit

final class SimilarCoordinator: Coordinator, CoordinationFinishDelegate {
    var childCoordinator: [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate?
    var identifier = UUID()
    weak var navigationController: UINavigationController?
    private var movieId: Int

    init(
        movieId: Int,
        navigationController: UINavigationController?,
        finishDelegate: CoordinationFinishDelegate
    ) {
        self.movieId = movieId
        self.navigationController = navigationController
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let similarViewModel = SimilarMoviesViewModel(
            movieId: movieId,
            movieUseCase: DiscoverUseCase(
                movieRepository: DefaultHomeRepository()
            ),
            searchUseCase: SearchUseCase(
                searchRepository: DefaultSearchRepository()
            )
        )
        similarViewModel.coordinator = self
        let similarMoviesViewController = SimilarMoviesViewController(viewModel: similarViewModel)
        self.navigationController?.pushViewController(similarMoviesViewController, animated: true)
    }
    
    func detailFlow(movieId: Int, movieName: String) {
        let detailCoordinator = DetailCoordinator(
            movieId: movieId,
            movieName: movieName,
            navigationController: self.navigationController,
            finishDelegate: self)
        self.childCoordinator.append(detailCoordinator)
        detailCoordinator.start()
    }
}
