//
//  NotificationListViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/2/21.
//

import UIKit

class NotificationListViewController: ParentDetailViewController, AuthenticableViewController {
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
        authenticate()
        FirebaseMessagingController.shared.requestNotificationPermissions(completion: {_ in })
        tableView.reloadData()
    }
    
    init(dataSource: CareNotificationController = CareNotificationController.shared) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
        setTabBar()
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Programmatic View")
    }
    
    private func setTabBar() {
        self.title = "Notifications"
        self.tabBarItem.image = UIImage(systemName: "bell")
        self.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveNotification),
                                               name: .newUnreadNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveNotification),
                                               name: .newReadNotification,
                                               object: nil)
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
    
    @objc func receiveNotification() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension NotificationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var notification: CareNotification?
        
        let cell = tableView.cellForRow(at: indexPath) as! CareNotificationTableViewCell
        let viewModel = cell.viewModel
        let id = viewModel?.id.uuidString ?? "1"
        
        switch indexPath.section {
        case CareNotificationDataSource.unread.rawValue:
            notification = self.dataSource.unread[id]
        case CareNotificationDataSource.read.rawValue:
            notification = self.dataSource.read[id]
        default:
            break
        }
        
        guard let notification = notification else { return }
        FirebaseMessagingController.shared.postMessage(type: .read, notification: notification)
        if indexPath.section == CareNotificationDataSource.unread.rawValue {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .newReadNotification, object: nil, userInfo: ["careNotification": notification])
            }
        }
        let vc = NotificationDetailViewController(notification: notification)
        self.showDetailViewController(vc, sender: nil)
        
    }
    
}
