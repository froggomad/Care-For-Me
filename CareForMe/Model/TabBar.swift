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
            return makeNavigationController(MainViewController())
        case .notifications:
            return makeNavigationController(NotificationListViewController())
        case .settings:
            return makeNavigationController(SettingsViewController())
        }
    }
    
    private func makeNavigationController(_ rootViewController: UIViewController) -> UINavigationController {
        UINavigationController(rootViewController: rootViewController)
    }
}
