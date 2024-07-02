//
//  SignUpCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 6/28/24.
//

import UIKit

final class SignUpCoordinator: Coordinator, CoordinationFinishDelegate {
    var childCoordinator: [Coordinator] = []
    weak var finishDelegate: CoordinationFinishDelegate?
    var identifier = UUID()
    var navigationController: UINavigationController?
    
    init(
        navigationController: UINavigationController?,
        finishDelegate: CoordinationFinishDelegate
    ) {
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
    }
    
    func start() {
        let signUpViewModel = SignUpViewModel()
        signUpViewModel.coordinator = self
        let signUpViewController = SignUpViewController(viewModel: signUpViewModel)
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
}
