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
    private var detailViewController: DetailViewController?
    
    private var movie: Movie
    
    init(
        movie: Movie,
        navigationController: UINavigationController?,
        finishDelegate: CoordinationFinishDelegate) {
            self.movie = movie
            self.navigationController = navigationController
            self.finishDelegate = finishDelegate
        }
    
    func start() {
        let detailViewModel = DetailViewModel(movie: movie)
        detailViewModel.coordinator = self
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func dismissDetailVC() {
        self.navigationController?.popViewController(animated: true)
        finish()
    }
}
