//
//  HomeCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import UIKit

final class HomeCoordinator: Coordinator, CoordinationFinishDelegate {
    var childCoordinator: [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate?
    let identifier = UUID()
    
    var navigationController: UINavigationController?
    
    private let tabBarItem: UITabBarItem = {
        let tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        return tabBarItem
    }()
    
    init(navigationController: UINavigationController?, finishDelegate: CoordinationFinishDelegate) {
        self.navigationController = navigationController
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let homeViewController = HomeViewController()
        self.navigationController = UINavigationController(rootViewController: homeViewController)
        let homeViewModel = HomeViewModel(
            movieUseCase: MovieUseCase(
                movieRepository: DefaultMovieRepository()
            )
        )
        homeViewModel.coordinator = self
        homeViewController.viewModel = homeViewModel
        self.navigationController?.tabBarItem = tabBarItem
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
