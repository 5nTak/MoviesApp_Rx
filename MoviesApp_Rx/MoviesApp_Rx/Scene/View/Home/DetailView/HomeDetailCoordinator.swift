//
//  HomeDetailCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import UIKit

final class DetailCoordinator: Coordinator, CoordinationFinishDelegate {
    var childCoordinator: [Coordinator] = []
    weak var finishDelegate: CoordinationFinishDelegate?
    let identifier = UUID()
    
    weak var navigationController: UINavigationController?
    
    private var movieId: Int
    
    init(
        movieId: Int,
        navigationController: UINavigationController?,
        finishDelegate: CoordinationFinishDelegate) {
            self.movieId = movieId
            self.navigationController = navigationController
            self.finishDelegate = finishDelegate
        }
    
    func start() {
        let detailViewModel = DetailViewModel(
            movieId: movieId,
            useCase: SearchUseCase(
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
            useCase: SearchUseCase(
                searchRepository: DefaultSearchRepository()
            )
        )
        let reviewsViewController = ReviewsViewController(viewModel: reviewsViewModel)
        self.navigationController?.pushViewController(reviewsViewController, animated: true)
    }
    
    func creditsFlow() {
        let creditsViewModel = CreditsViewModel(
            movieId: movieId,
            useCase: SearchUseCase(
                searchRepository: DefaultSearchRepository()
            )
        )
        let creditsViewController = CreditsViewController(viewModel: creditsViewModel)
        self.navigationController?.pushViewController(creditsViewController, animated: true)
    }
}
