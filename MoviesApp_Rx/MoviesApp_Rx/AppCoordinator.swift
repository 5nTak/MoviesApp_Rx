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
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
}
