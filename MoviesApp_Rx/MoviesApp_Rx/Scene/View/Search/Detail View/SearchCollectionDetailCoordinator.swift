//
//  SearchCollectionDetailCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/22/24.
//

import UIKit

final class SearchCollectionDetailCoordinator: Coordinator, CoordinationFinishDelegate {
    var childCoordinator: [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate?
    var identifier = UUID()
    
    var navigationController: UINavigationController?
    
    private var id: Int
    private var title: String
    
    init(
        id: Int,
        title: String,
        finishDelegate: CoordinationFinishDelegate,
        navigationController: UINavigationController?
    ) {
        self.id = id
        self.title = title
        self.navigationController = navigationController
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        start(id: id, title: title)
    }
    
    func start(id: Int, title: String) {
        let collectionDetailViewModel = SearchCollectionDetailViewModel(
            id: id,
            title: title,
            searchUseCase: SearchUseCase(
                searchRepository: DefaultSearchRepository(
                    networkProvider: DefaultNetworkProvider()
                )
            )
        )
        collectionDetailViewModel.coordinator = self
        let collectionDetailViewController = SearchCollectionDetailViewController(viewModel: collectionDetailViewModel)
        self.navigationController?.pushViewController(collectionDetailViewController, animated: true)
    }
    
    func detailFlow(with movie: Movie, title: String) {
        let detailCoordinator = DetailCoordinator(
            movie: movie,
            title: title,
            navigationController: self.navigationController,
            finishDelegate: self)
        self.childCoordinator.append(detailCoordinator)
        detailCoordinator.start()
    }
}
