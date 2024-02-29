//
//  AccountCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/07.
//

import UIKit

final class AccountCoordinator: Coordinator, CoordinationFinishDelegate {
    var childCoordinator: [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate?
    var identifier = UUID()
    let tabBarItem: UITabBarItem = {
        let tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        return tabBarItem
    }()
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?, finishDelegate: CoordinationFinishDelegate) {
        self.navigationController = navigationController
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let accountViewController = AccountViewController()
        self.navigationController = UINavigationController(rootViewController: accountViewController)
        let accountViewModel = AccountViewModel()
        accountViewModel.coordinator = self
        accountViewController.viewModel = accountViewModel
        self.navigationController?.tabBarItem = tabBarItem
    }
}
