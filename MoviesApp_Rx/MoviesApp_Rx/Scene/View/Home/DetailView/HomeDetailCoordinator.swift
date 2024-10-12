//
//  HomeDetailCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import UIKit

final class DetailCoordinator: Coordinator, CoordinationFinishDelegate {
    var childCoordinator: [Coordinator] = []
    let identifier = UUID()
    weak var finishDelegate: CoordinationFinishDelegate?
    weak var navigationController: UINavigationController?
    private var movieId: Int
    private var movieName: String
    
    init(
        movieId: Int,
        movieName: String,
        navigationController: UINavigationController?,
        finishDelegate: CoordinationFinishDelegate) {
            self.movieId = movieId
            self.movieName = movieName
            self.navigationController = navigationController
            self.finishDelegate = finishDelegate
        }
    
    func start() {
        let detailViewModel = DetailViewModel(
            movieId: movieId,
            movieInfoUseCase: MovieInfoUseCase(
                homeRepository: DefaultHomeRepository(),
                accountRepository: DefaultAccountRepository()
            ),
            genreUseCase: GenreUseCase(
                searchRepository: DefaultSearchRepository()
            )
        )
        detailViewModel.coordinator = self
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func reviewsFlow() {
        let reviewsViewModel = ReviewsViewModel(
            movieId: movieId,
            movieName: movieName,
            useCase: SearchUseCase(
                searchRepository: DefaultSearchRepository()
            )
        )
        let reviewsViewController = ReviewsViewController(viewModel: reviewsViewModel)
        self.navigationController?.pushViewController(reviewsViewController, animated: true)
    }
    
    func trailersFlow() {
        let trailerViewModel = TrailersViewModel(
            movieId: movieId,
            movieName: movieName,
            useCase: SearchUseCase(
                searchRepository: DefaultSearchRepository()
            )
        )
        let trailersController = TrailersController(viewModel: trailerViewModel)
        self.navigationController?.pushViewController(trailersController, animated: true)
    }
    
    func creditsFlow() {
        let creditsViewModel = CreditsViewModel(
            movieId: movieId,
            movieName: movieName,
            useCase: SearchUseCase(
                searchRepository: DefaultSearchRepository()
            )
        )
        let creditsViewController = CreditsViewController(viewModel: creditsViewModel)
        self.navigationController?.pushViewController(creditsViewController, animated: true)
    }
    
    func similarFlows() {
        let similarCoordinator = SimilarCoordinator(
            movieId: movieId,
            navigationController: navigationController,
            finishDelegate: self
        )
        self.childCoordinator.append(similarCoordinator)
        similarCoordinator.start()
    }
}
