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
    
    private var item: ItemData
    
    init(
        item: ItemData,
        navigationController: UINavigationController?,
        finishDelegate: CoordinationFinishDelegate) {
            self.item = item
            self.navigationController = navigationController
            self.finishDelegate = finishDelegate
        }
    
    func start() {
        if let movie = item as? Movie {
            startFromHome(movie: movie)
        } else if let collection = item as? Collection {
            startFromSearch(collection: collection)
        }
    }
    
    func startFromHome(movie: Movie) {
        let detailViewModel = DetailViewModel(movie: movie)
        detailViewModel.coordinator = self
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func startFromSearch(collection: Collection) {
        let detailViewModel = DetailViewModel(collection: collection)
        detailViewModel.coordinator = self
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
