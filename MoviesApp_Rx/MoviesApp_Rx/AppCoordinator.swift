//
//  AppCoordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    var finishDelegate: CoordinationFinishDelegate?
    
    let identifier = UUID()
    
    var childCoordinator: [Coordinator] = []
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func setupTabs(for tabBar: MainTabBarController) {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController, finishDelegate: self)
        let searchCoordinator = SearchCoordinator(navigationController: navigationController, finishDelegate: self)
        let accountCoordinator = AccountCoordinator(navigationController: navigationController, finishDelegate: self)
        
        homeCoordinator.start()
        searchCoordinator.start()
        accountCoordinator.start()
        
        tabBar.setupTabs(with: [homeCoordinator, searchCoordinator, accountCoordinator])
    }
    
    func start() {
        let rootViewController = MainTabBarController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        self.setupTabs(for: rootViewController)
    }
}

extension AppCoordinator: CoordinationFinishDelegate { }
