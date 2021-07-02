//
//  CareNotificationController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/2/21.
//

import UIKit

class CareNotificationController: NSObject {
    private let dbController = FirebaseDatabaseController()
    
    var read: [CareNotification]
    var unread: [CareNotification]
    
    init(read: [CareNotification], unread: [CareNotification]) {
        self.read = read
        self.unread = unread
    }
    
    func getNotificationsFromAPI() {
        
    }
}


extension CareNotificationController: UITableViewDataSource {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CareNotificationTableViewCell.identifier) as! CareNotificationTableViewCell
        
        cell.viewModel = NotificationCellViewModel(category: "Foo", title: "Bar", message: "Test")
        
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

enum CareNotificationDataSource: Int {
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

