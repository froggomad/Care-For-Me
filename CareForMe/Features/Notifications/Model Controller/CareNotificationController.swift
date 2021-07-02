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
        
        // TODO: viewModel
        
        return cell
        
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return [CareNotificationDataSource.read.title,
                CareNotificationDataSource.unread.title]
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

