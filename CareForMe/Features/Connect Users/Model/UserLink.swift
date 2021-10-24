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
    let code: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(String.self, forKey: .userId)
        
        let userTypeString = try container.decode(String.self, forKey: .userId)
        let userType = UserType(rawValue: userTypeString) ?? .client
        self.userType = userType
        
        self.username = try container.decode(String.self, forKey: .username)
        
        self.code = decoder.codingPath.first?.stringValue ?? ""
    }
}

struct UserLink: Codable {
    let caregiverId: String?
    let clientId: String?
    var joinCode: String?
    
    enum CodingKeys: String, CodingKey {
        case caregiverId = "caregiver"
        case clientId = "client"
        case joinCode = "code"
    }
    
    init(from dictionary: [String: Any]) {
        self.caregiverId = dictionary[CodingKeys.caregiverId.rawValue] as? String
        self.clientId = dictionary[CodingKeys.clientId.rawValue] as? String
        self.joinCode = dictionary[CodingKeys.joinCode.rawValue] as? String
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        caregiverId = try container.decodeIfPresent(String.self, forKey: .caregiverId)
        clientId = try container.decodeIfPresent(String.self, forKey: .clientId)
        joinCode = try container.decode(String.self, forKey: .joinCode)
    }
}

extension Date {
    func adding(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
}
