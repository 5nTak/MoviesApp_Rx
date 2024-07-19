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
    
    private var movie: Movie
    private var movieId: Int
    private let title: String
    
    init(
        movie: Movie,
        title: String,
        movieId: Int,
        navigationController: UINavigationController?,
        finishDelegate: CoordinationFinishDelegate) {
            self.movie = movie
            self.title = title
            self.movieId = movieId
            self.navigationController = navigationController
            self.finishDelegate = finishDelegate
        }
    
    func start() {
        start(movie: movie)
    }
    
    private func start(movie: Movie) {
        let detailViewModel = DetailViewModel(movie: movie, title: self.title, movieId: movieId)
        detailViewModel.coordinator = self
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
