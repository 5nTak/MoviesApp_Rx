//
//  AppCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var finishDelegate: CoordinationFinishDelegate? = nil
    
    let identifier = UUID()
    
    var childCoordinator: [Coordinator] = []
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let rootViewController = MainTabBarController()
        
        let homeCoordinator = HomeCoordinator(navigationController: rootViewController.viewControllers?[0] as? UINavigationController ?? UINavigationController())
//        let searchCoordinator = searchCoordinator(navigationController: rootViewController.viewControllers[1] as? UINavigationController ?? UINavigationController())
//        let accountCoordinator = accountCoordinator(navigationController: rootViewController.viewControllers[2] as? UINavigationController ?? UINavigationController())
//
        homeCoordinator.start()
//        searchCoordinator.start()
//        accountCoordinator.start()
//
        childCoordinator.append(contentsOf: [homeCoordinator])
        
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
}
