//
//  UserLink.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/7/21.
//

import Foundation

struct UserLink: Codable {
    let caregiverId: String?
    let clientId: String?
    var joinCode: String?
    var expiresOn: Date
    
    init(caregiverId: String?, clientId: String?, joinCode: String? = nil, expiresOn: Date = Date().adding(days: 7) ?? Date()) {
        self.caregiverId = caregiverId
        self.clientId = clientId
        if joinCode == nil {
            self.joinCode = Int.randomString()
        } else {
            self.joinCode = joinCode
        }
        self.expiresOn = expiresOn
    }
}

struct UserLinkController {
    private static let dbController = FirebaseDatabaseController()
    
    static func sendLinkToDatabase(link: UserLink) {
        dbController.setUserValue(for: .userLinkRef, with: link)
    }
}

extension Date {
    func adding(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
}
