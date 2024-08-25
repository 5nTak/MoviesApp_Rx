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
        let exploreViewModel = ExploreViewModel(
            movieId: movieId,
            useCase: SearchUseCase(
                searchRepository: DefaultSearchRepository()
            )
        )
        let reviewsViewController = ReviewsViewController(viewModel: exploreViewModel)
        self.navigationController?.pushViewController(reviewsViewController, animated: true)
    }
}
