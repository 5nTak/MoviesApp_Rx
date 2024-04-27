//
//  HomeDetailCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import UIKit

final class DetailCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    weak var finishDelegate: CoordinationFinishDelegate?
    let identifier = UUID()
    
    weak var navigationController: UINavigationController?
    
    private var movie: Movie
    private let title: String
    
    init(
        movie: Movie,
        title: String,
        navigationController: UINavigationController?,
        finishDelegate: CoordinationFinishDelegate) {
            self.movie = movie
            self.title = title
            self.navigationController = navigationController
            self.finishDelegate = finishDelegate
        }
    
    func start() {
        start(movie: movie)
    }
    
    func start(movie: Movie) {
        let detailViewModel = DetailViewModel(movie: movie, title: self.title)
        detailViewModel.coordinator = self
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
