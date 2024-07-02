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
            viewControllers.append(navigationController)
        }
        
        self.viewControllers = viewControllers
    }
    
    func updateAccountTab(to viewController: UIViewController) {
        guard var viewControllers = self.viewControllers else { return }
        
        for (index, vc) in viewControllers.enumerated() {
            if let navVC = vc as? UINavigationController, navVC.tabBarItem.title == "Account" {
                viewControllers[index] = UINavigationController(rootViewController: viewController)
                self.viewControllers = viewControllers
                break
            }
        }
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .systemGray6
    }
}
