//
//  SearchCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/20.
//

import UIKit

final class SearchCoordinator: Coordinator, CoordinationFinishDelegate {
    var childCoordinator: [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate?
    var identifier = UUID()
    let tabBarItem: UITabBarItem = {
        let tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass.circle"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )
        return tabBarItem
    }()
    
    var navigationController: UINavigationController?
    
    private var searchText: String?
    
    init(
        navigationController: UINavigationController?,
        finishDelegate: CoordinationFinishDelegate
    ) {
        self.navigationController = navigationController
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let searchViewController = SearchViewController()
        self.navigationController = UINavigationController(rootViewController: searchViewController)
        let searchViewModel = SearchViewModel(
            searchMovieUseCase: SearchUseCase(
                searchRepository: DefaultSearchRepository()
            )
        )
        searchViewModel.coordinator = self
        searchViewController.viewModel = searchViewModel
        self.navigationController?.tabBarItem = tabBarItem
    }
    
    func detailMovieFlow(with movie: Movie, title: String) {
        let detailCoordinator = DetailCoordinator(
            contents: movie,
            title: title,
            navigationController: self.navigationController,
            finishDelegate: self)
        self.childCoordinator.append(detailCoordinator)
        detailCoordinator.start()
    }
    
    func detailCollectionFlow(with id: Int, title: String) {
        let searchCollectionDetailCoordinator = SearchCollectionDetailCoordinator(
            id: id,
            title: title,
            finishDelegate: self,
            navigationController: self.navigationController
        )
        self.childCoordinator.append(searchCollectionDetailCoordinator)
        searchCollectionDetailCoordinator.start()
    }
}
