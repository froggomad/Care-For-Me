//
//  CareNotification.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/2/21.
//

import Foundation

struct CareNotification: Codable, Equatable {
    let id: UUID
    let category: String
    let title: String
    let text: String
    let forUserId: String
    let date: Date
    
    static func ==(lhs: CareNotification, rhs: CareNotification) -> Bool {
        lhs.id == rhs.id
    }
    
    var viewModel: NotificationCellViewModel {
        NotificationCellViewModel(id: id, category: category, title: title, message: text)
    }
    
    var categoryTitle: String {
        "\(category): \(title)"
    }
}
