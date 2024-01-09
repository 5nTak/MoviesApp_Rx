//
//  HomeCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate? = nil
    let identifier = UUID()
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewController = HomeViewController()
        let homeViewModel = HomeViewModel(movieUseCase: MovieUseCase(movieRepository: DefaultMovieRepository()))
        homeViewController.viewModel = homeViewModel
        
        navigationController.pushViewController(homeViewController, animated: true)
    }
}
