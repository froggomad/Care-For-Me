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
    case settings
    
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
    
    var rootViewController: UIViewController {
        switch self {
        case .main:
            return MainViewController()
        case .notifications:
            return NotificationListViewController()
        case .settings:
            return SettingsViewController()
        }
    }
    
    var navigationController: UINavigationController {
        self.makeNavigationController(rootViewController)
    }
    
    private func makeNavigationController(_ rootViewController: UIViewController) -> UINavigationController {
        UINavigationController(rootViewController: rootViewController)
    }
}
