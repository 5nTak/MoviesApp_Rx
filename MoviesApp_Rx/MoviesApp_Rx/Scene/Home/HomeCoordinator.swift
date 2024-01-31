//
//  HomeCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import UIKit

final class HomeCoordinator: Coordinator, CoordinationFinishDelegate {
    var childCoordinator: [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate? = nil
    let identifier = UUID()
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewController = HomeViewController()
        let homeViewModel = HomeViewModel(
            movieUseCaseRx: MovieUseCaseRx(movieRepositoryRx: DefaultMovieRepositoryRx()
            )
        )
        homeViewModel.coordinator = self
        homeViewController.viewModel = homeViewModel
        
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func detailFlow(with movie: Movie) {
        let detailCoordinator = DetailCoordinator(
            movie: movie,
            navigationController: self.navigationController,
            finishDelegate: self)
        self.childCoordinator.append(detailCoordinator)
        detailCoordinator.start()
    }
}
