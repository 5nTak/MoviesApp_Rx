//
//  HomeDetailCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import UIKit

final class DetailCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate?
    let identifier = UUID()
    
    private let navigationController: UINavigationController
    private var detailViewController: DetailViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let detailViewController = DetailViewController()
        let detailViewModel = DetailViewModel()
        detailViewController.viewModel = detailViewModel
        self.detailViewController = detailViewController
        
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
