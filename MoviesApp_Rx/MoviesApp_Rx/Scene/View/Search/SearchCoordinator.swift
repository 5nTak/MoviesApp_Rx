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
    var navigationController: UINavigationController?
    
    private var searchText: String?
    
    let tabBarItem: UITabBarItem = {
        let tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass.circle"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )
        return tabBarItem
    }()
    
    init(
        navigationController: UINavigationController?,
        finishDelegate: CoordinationFinishDelegate
    ) {
        self.navigationController = navigationController
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let searchViewModel = SearchViewModel(
            movieUseCase: MovieUseCase(
                movieRepository: DefaultMovieRepository()
            ),
            searchMovieUseCase: SearchUseCase(
                searchRepository: DefaultSearchRepository()
            )
        )
        searchViewModel.coordinator = self
        let searchViewController = SearchViewController(viewModel: searchViewModel)
        self.navigationController = UINavigationController(rootViewController: searchViewController)
        self.navigationController?.tabBarItem = tabBarItem
    }
    
    func detailMovieFlow(title: String, movieId: Int) {
        let detailCoordinator = DetailCoordinator(
            movieId: movieId,
            movieName: title,
            navigationController: self.navigationController,
            finishDelegate: self
        )
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
    
    func popularMoviesFlow(page: Int) {
        let popularMoviesCoordinator = PopularCoordinator(
            navigationController: self.navigationController,
            finishDelegate: self
        )
        self.childCoordinator.append(popularMoviesCoordinator)
        popularMoviesCoordinator.start()
    }
    
    func topRatedMoviesFlow(page: Int) {
        let topRatedMoviesCoordinator = TopRatedCoordinator(
            navigationController: self.navigationController,
            finishDelegate: self
        )
        self.childCoordinator.append(topRatedMoviesCoordinator)
        topRatedMoviesCoordinator.start()
    }
    
    func genreDetailFlow(id: Int, name: String) {
        let genreCoordinator = GenreCoordinator(
            id: id,
            name: name,
            navigationController: self.navigationController,
            finishDelegate: self
        )
        self.childCoordinator.append(genreCoordinator)
        genreCoordinator.start()
    }
}
