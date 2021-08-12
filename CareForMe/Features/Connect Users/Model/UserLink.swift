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
    var joinCode: String = Int.randomString()
}

struct UserLinkController {
    private static let dbController = FirebaseDatabaseController()
    
    static func sendLinkToDatabase(link: UserLink) {
        dbController.setValue(for: .userLink, with: link)
    }
}
