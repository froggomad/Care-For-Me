//
//  CareNotificationController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/2/21.
//

import UIKit


class CareNotificationController: NSObject {
    private struct NotificationData: Codable {
        var read: [CareNotification]
        var unread: [CareNotification]
    }
    
    private let dbController = FirebaseDatabaseController()
    
    var read: [CareNotification]
    var unread: [CareNotification]
    
    init(read: [CareNotification], unread: [CareNotification]) {
        self.read = read
        self.unread = unread
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveUnreadNotification(_:)),
                                               name: .newUnreadNotification,
                                               object: nil)
    }
    
    func getNotificationsFromAPI(for userId: String) {
        dbController.observe(endpoint: APIRef.userNotifications(userId: userId).endpoint, event: .value) { snapshot in
            guard let notification = try? snapshot.data(as: NotificationData.self) else {
                return
            }
            self.read = notification.read
            self.unread = notification.unread
        }
    }
    
    @objc private func receiveUnreadNotification(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard let careNotification = userInfo?["careNotification"] as? CareNotification else { return }
        
        if !unread.contains(careNotification) {
            unread.append(careNotification)
        }
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
            viewModel = read[indexPath.item].viewModel
        case CareNotificationDataSource.unread.sectionNumber:
            viewModel = unread[indexPath.item].viewModel
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
}
