//
//  NotificationListViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/2/21.
//

import UIKit

class NotificationListViewController: UIViewController {
    
    let tableView: NotificationListTableView = {
        // TODO: Use live controller
        let dataSource = CareNotificationController(read: [CareNotification(id: UUID(), title: "Title", message: "Hello", forUserId: "1", date: Date())], unread: [])
        let tableView = NotificationListTableView(dataSource: dataSource)
        return tableView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        subviews()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Programmatic View")
    }
    
    private func setTabBar() {
        self.title = "Notifications"
        self.tabBarItem.image = UIImage(systemName: "bell")
        self.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
    }
    
    private func subviews() {
        view.addSubview(tableView)
        constraints()
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
}
