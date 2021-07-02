//
//  NotificationListTableView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/2/21.
//

import UIKit

class NotificationListTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    init(dataSource: CareNotificationController) {
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = dataSource
        register(CareNotificationTableViewCell.self, forCellReuseIdentifier: CareNotificationTableViewCell.identifier)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
}
