//
//  UserLink.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/7/21.
//

import Foundation

struct UserLink: Codable {
    let caregiver: CaregiverUser
    let client: ClientUser
    var joinCode: String?
    var expiresOn: Date
    
    init(caregiver: CaregiverUser, client: ClientUser, joinCode: String? = nil, expiresOn: Date = Date().adding(days: 7) ?? Date()) {
        self.caregiver = caregiver
        self.client = client
        if joinCode == nil {
            self.joinCode = Int.randomString()
            // TODO: save joinCode
        } else {
            self.joinCode = joinCode
        }
        self.expiresOn = expiresOn
    }
    
    init(caregiver: CaregiverUser, client: ClientUser, joinCode: String, expiresOn: Date) {
        self.caregiver = caregiver
        self.client = client
        self.joinCode = joinCode
        self.expiresOn = expiresOn
    }
}

struct UserLinkController {
    private static let dbController = FirebaseDatabaseController()
    
    static func sendLinkToDatabase(link: UserLink) {
        dbController.setUserValue(for: .userLink, with: link)
    }
}

extension Date {
    func adding(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
}
