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
    
    static func createMainTabBar() -> MainTabController {
        let tabBar = MainTabController()
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

class MainTabController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        listenForLogout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic controller")
    }
    
    private func listenForLogout() {
        NotificationCenter.default.addObserver(forName: .userLoggedOut, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.modalTransitionStyle = .flipHorizontal
            self.present(loginVC, animated: true)
        }
    }
}

private enum NavigationViewController {
    
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
        UINavigationController(rootViewController: rootViewController)
    }
    
}
