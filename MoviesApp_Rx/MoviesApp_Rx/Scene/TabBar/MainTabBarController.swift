//
//  MainTabBarController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/21.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabs(with coordinators: [Coordinator]) {
            var viewControllers: [UIViewController] = []

            for coordinator in coordinators {
                guard let navigationController = coordinator.navigationController else {
                    continue
                }

                let viewController = navigationController.viewControllers.first
                viewControllers.append(navigationController)
            }

            self.viewControllers = viewControllers
        }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .systemGray
    }
}
