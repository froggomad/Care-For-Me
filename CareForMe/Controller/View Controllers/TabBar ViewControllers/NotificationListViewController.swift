//
//  NotificationListViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/2/21.
//

import UIKit

class NotificationListViewController: UIViewController {
    
    var dataSource: CareNotificationController
    
    lazy var tableView: NotificationListTableView = {
        let tableView = NotificationListTableView(dataSource: self.dataSource)
        return tableView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        subviews()
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    init(dataSource: CareNotificationController = CareNotificationController(read: [], unread: [])) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
        setTabBar()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveUnreadNotification(_:)),
                                               name: .newUnreadNotification,
                                               object: nil)
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
    
    @objc private func receiveUnreadNotification(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}

extension NotificationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var notification: CareNotification?
        
        switch indexPath.section {
        case CareNotificationDataSource.unread.rawValue:
            notification = dataSource.unread[indexPath.item]
        case CareNotificationDataSource.read.rawValue:
            notification = dataSource.read[indexPath.item]
        default:
            break
        }
        
        guard let notification = notification else { return }
        let vc = NotificationDetailViewController(notification: notification)
        showDetailViewController(vc, sender: nil)
    }
}
