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
    
    private var contents: Contents
    private let title: String
    
    init(
        contents: Contents,
        title: String,
        navigationController: UINavigationController?,
        finishDelegate: CoordinationFinishDelegate) {
            self.contents = contents
            self.title = title
            self.navigationController = navigationController
            self.finishDelegate = finishDelegate
        }
    
    func start() {
        start(contents: contents)
    }
    
    private func start(contents: Contents) {
        let detailViewModel = DetailViewModel(movie: contents as! Movie, title: self.title)
        detailViewModel.coordinator = self
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
