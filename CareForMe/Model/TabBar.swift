//
//  TabBar.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/4/21.
//

import UIKit

enum TabBar: Int {
    case main
    case notifications
    
    static func createMainTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [
            NavigationViewController.main.navigationController,
            NavigationViewController.notifications.navigationController,
            NavigationViewController.settings.navigationController
        ]
        return tabBar
    }
    
    static func activate(_ tab: TabBar) {
        guard let tabBarController = UIApplication.shared.windows.first?.rootViewController as? UITabBarController else { return }
        tabBarController.selectedIndex = tab.rawValue
    }
}

enum NavigationViewController {
    
    case main
    case notifications
    case settings
    
    var navigationController: UINavigationController {
        switch self {
        case .main:
            let navController = UINavigationController(rootViewController: MainViewController())
            return navController
        case .notifications:
            let navController = UINavigationController(rootViewController: NotificationListViewController())
            return navController
        case .settings:
            let navController = UINavigationController(rootViewController: SettingsViewController())
            return navController
        }
    }
}
