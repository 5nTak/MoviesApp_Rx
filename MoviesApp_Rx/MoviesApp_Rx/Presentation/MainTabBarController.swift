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
        setupTabBarItem()
    }
    
    private func setupTabBarItem() {
        let mainViewController = MainView()
        mainViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let searchViewController = UIViewController()
        searchViewController.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass.circle"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )
        
        let accountViewController = UIViewController()
        accountViewController.tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        let mainTabNavigation = UINavigationController(rootViewController: mainViewController)
        let searchTabNavigation = UINavigationController(rootViewController: searchViewController)
        let accountTabNavigation = UINavigationController(rootViewController: accountViewController)
        
        viewControllers = [
            mainTabNavigation,
            searchTabNavigation,
            accountTabNavigation
        ]
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .systemGray
    }
}
