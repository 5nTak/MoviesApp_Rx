//
//  GenreCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/14/24.
//

import UIKit

final class GenreCoordinator: Coordinator, CoordinationFinishDelegate {
    var childCoordinator: [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate?
    var navigationController: UINavigationController?
    var identifier = UUID()
    let id: Int
    let name: String
    
    init(
        id: Int,
        name: String,
        navigationController: UINavigationController?,
        finishDelegate: CoordinationFinishDelegate
    ) {
        self.id = id
        self.name = name
        self.navigationController = navigationController
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let genreDetailViewModel = GenreDetailViewModel(
            useCase: MovieUseCase(
                movieRepository: DefaultMovieRepository(
                    networkProvider: DefaultNetworkProvider()
                )
            ),
            id: id,
            name: name
        )
        genreDetailViewModel.coordinator = self
        let genreDetailViewController = GenreDetailViewController(viewModel: genreDetailViewModel)
        self.navigationController?.pushViewController(genreDetailViewController, animated: true)
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
