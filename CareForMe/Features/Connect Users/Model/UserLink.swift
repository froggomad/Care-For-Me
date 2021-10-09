//
//  UserLink.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/7/21.
//

import Foundation

struct JoinRequest: Codable {
    let userId: String
    let userType: UserType
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(String.self, forKey: .userId)
        let userTypeString = try container.decode(String.self, forKey: .userId)
        let userType = UserType(rawValue: userTypeString) ?? .client
        self.userType = userType
    }
}

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

extension Date {
    func adding(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
}
