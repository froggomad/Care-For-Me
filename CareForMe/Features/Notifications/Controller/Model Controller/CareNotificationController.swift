//
//  CareNotificationController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/2/21.
//

import UIKit

class CareNotificationController: NSObject {
    static let shared = CareNotificationController()
    
    private struct NotificationData: Codable {
        var read: [CareNotification]
        var unread: [CareNotification]
    }
    
    private let dbController = FirebaseDatabaseController()
    
    var read: [String: CareNotification]
    var unread: [String: CareNotification]
    
    override private init() {
        self.read = [:]
        self.unread = [:]
        super.init()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveUnreadNotification(_:)),
                                               name: .newUnreadNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveReadNotification(_:)),
                                               name: .newReadNotification,
                                               object: nil)
    }
    
    func getNotificationsFromAPI(for userId: String) {
        dbController.observe(endpoint: .userNotifications(userId: userId), event: .value) { [weak self] snapshot in
            guard let notification = try? snapshot.data(as: NotificationData.self) else {
                print("unable to parse notifications as NotificationData")
                return
            }
            var readHashMap: Dictionary<String, CareNotification> = [:]
            for notification in notification.read {
                readHashMap[notification.id.uuidString] = notification
            }
            self?.read = readHashMap
                        
            var unreadHashMap: Dictionary<String, CareNotification> = [:]
            for notification in notification.unread {
                unreadHashMap[notification.id.uuidString] = notification
            }
            self?.unread = unreadHashMap
        }
    }
    
    @objc private func receiveUnreadNotification(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard let careNotification = userInfo?["careNotification"] as? CareNotification else { return }
        
        unread[careNotification.id.uuidString] = careNotification
    }
    
    @objc private func receiveReadNotification(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard let careNotification = userInfo?["careNotification"] as? CareNotification else { return }
        
        if let unreadNotification = unread[careNotification.id.uuidString] {
            unread.removeValue(forKey: unreadNotification.id.uuidString)
        }
        
        read[careNotification.id.uuidString] = careNotification
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension CareNotificationController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        CareNotificationDataSource.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CareNotificationDataSource.read.sectionNumber:
            return read.count
        case CareNotificationDataSource.unread.sectionNumber:
            return unread.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var viewModel: NotificationCellViewModel?
        
        switch indexPath.section {
        case CareNotificationDataSource.read.sectionNumber:
            let readIds = read.map { $0.key }
            let readId = readIds[indexPath.item]
            viewModel = read[readId]?.viewModel
        case CareNotificationDataSource.unread.sectionNumber:
            let unreadIds = unread.map { $0.key }
            let unreadId = unreadIds[indexPath.item]
            viewModel = unread[unreadId]?.viewModel
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CareNotificationTableViewCell.identifier) as! CareNotificationTableViewCell
        
        cell.viewModel = viewModel
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case CareNotificationDataSource.read.sectionNumber:
            return CareNotificationDataSource.read.title
        case CareNotificationDataSource.unread.sectionNumber:
            return CareNotificationDataSource.unread.title
        default:
            return ""
        }
    }
    
}

enum CareNotificationDataSource: Int, CaseIterable {
    case read
    case unread
    
    var sectionNumber: Int {
        rawValue
    }
    
    var title: String {
        switch self {
        case .read:
            return "Read"
        case .unread:
            return "Unread"
        }
    }
}

extension Notification.Name {
    static let newUnreadNotification = Notification.Name("NewUnreadNotification")
    static let newReadNotification = Notification.Name("NewReadNotification")
}
