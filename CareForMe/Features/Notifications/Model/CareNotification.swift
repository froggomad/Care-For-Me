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
    
    init(id: UUID, category: String, title: String, text: String, forUserId: String, date: Date) {
        self.id = id
        self.category = category
        self.title = title
        self.text = text
        self.forUserId = forUserId
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        category = try container.decode(String.self, forKey: .category)
        title = try container.decode(String.self, forKey: .title)
        text = try container.decode(String.self, forKey: .text)
        forUserId = try container.decode(String.self, forKey: .forUserId)
        let seconds = Double(try container.decode(Int.self, forKey: .date))
        date = Date(timeIntervalSince1970: seconds)
    }
}
