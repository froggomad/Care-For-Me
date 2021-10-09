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
    let username: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(String.self, forKey: .userId)
        
        let userTypeString = try container.decode(String.self, forKey: .userId)
        let userType = UserType(rawValue: userTypeString) ?? .client
        self.userType = userType
        
        self.username = try container.decode(String.self, forKey: .username)
    }
}

struct UserLink: Codable {
    let caregiverId: String?
    let clientId: String?
    var joinCode: String?
    var expiresOn: Date
    
    enum CodingKeys: String, CodingKey {
        case caregiverId = "caregiver"
        case clientId = "client"
        case joinCode = "code"
        case expiresOn
    }
    
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        caregiverId = try container.decode(String.self, forKey: .caregiverId)
        clientId = try container.decode(String.self, forKey: .clientId)
        joinCode = try container.decode(String.self, forKey: .joinCode)
        let dateString = try container.decode(String.self, forKey: .expiresOn)
        expiresOn = DateFormatter.firebaseStringToDate(from: dateString)
    }
}

extension Date {
    func adding(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
}
