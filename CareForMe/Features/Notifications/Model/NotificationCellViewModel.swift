//
//  NotificaitonCellViewModel.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/2/21.
//

import UIKit

struct NotificationCellViewModel {
    init(id: UUID, category: String, title: String, message: String) {
        let uuid = UUID(uuidString: id.uuidString.lowercased()) ?? UUID()
        self.id = uuid
        self.category = category
        self.title = title
        self.message = message
    }
    
    var id: UUID
    var category: String
    var title: String
    var message: String
}
