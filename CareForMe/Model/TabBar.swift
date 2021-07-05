//
//  TabBar.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/4/21.
//

import UIKit

enum TabBar {
    static func createMainTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [
            NavigationViewController.main.navigationController,
            NavigationViewController.notifications.navigationController
        ]
        return tabBar
    }
}

enum NavigationViewController {
    
    case main
    case notifications
    
    var navigationController: UINavigationController {
        switch self {
        case .main:
            let navController = UINavigationController(rootViewController: MainViewController())
            return navController
        case .notifications:
            let navController = UINavigationController(rootViewController: NotificationListViewController())
            return navController
        }
    }
}
