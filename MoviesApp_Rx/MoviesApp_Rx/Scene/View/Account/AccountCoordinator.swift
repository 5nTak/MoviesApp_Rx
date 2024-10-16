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
    var navigationController: UINavigationController?
    let tabBarItem: UITabBarItem = {
        let tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        return tabBarItem
    }()
    
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
    
    func showSignUp() {
        let signUpCoordinator = SignUpCoordinator(
            navigationController: self.navigationController,
            finishDelegate: self
        )
        signUpCoordinator.start()
    }
    
    func showMyInfo(email: String) {
        let myInfoViewController = MyInfoViewController()
        let myInfoViewModel = MyInfoViewModel(
            email: email,
            movieInfoUseCase: MovieInfoUseCase(
                homeRepository: DefaultHomeRepository(),
                accountRepository: DefaultAccountRepository()
            )
        )
        myInfoViewModel.coordinator = self
        myInfoViewController.viewModel = myInfoViewModel
        self.navigationController?.setViewControllers([myInfoViewController], animated: true)
    }
    
    func showLogin() {
        let accountViewController = AccountViewController()
        let accountViewModel = AccountViewModel()
        accountViewModel.coordinator = self
        accountViewController.viewModel = accountViewModel
        self.navigationController?.setViewControllers([accountViewController], animated: true)
    }
    
    func detailFlow(title: String, movieId: Int) {
        let detailCoordinator = DetailCoordinator(
            movieId: movieId,
            movieName: title,
            navigationController: self.navigationController,
            finishDelegate: self)
        self.childCoordinator.append(detailCoordinator)
        detailCoordinator.start()
    }
}
