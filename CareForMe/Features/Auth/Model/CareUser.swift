//
//  User.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/30/21.
//

import Foundation
import Firebase

class CareUser: Codable {
    
    let userId: String
    let displayName: String
    
    convenience init(authUser: User) {
        self.init(userId: authUser.uid, displayName: authUser.displayName ?? "")
    }
    
    init(userId: String, displayName: String) {
        self.userId = userId
        self.displayName = displayName
    }
    
}

class ClientUser: CareUser {
    weak var caregiver: CaregiverUser?
    /// init user without caregiver
    required override init(userId: String, displayName: String) {
        super.init(userId: userId, displayName: displayName)
    }
    /// init user with caregiver
    required init(userId: String, displayName: String, caregiver: CaregiverUser) {
        super.init(userId: userId, displayName: displayName)
        self.caregiver = caregiver
    }
    /// init user from Firebase
    required init(from decoder: Decoder) throws {
        #warning("This isn't tested")
        try super.init(from: decoder)
    }
}

class CaregiverUser: CareUser {
    weak var client: ClientUser?
    /// init user without client
    required override init(userId: String, displayName: String) {
        super.init(userId: userId, displayName: displayName)
    }
    /// init user with client
    required init(userId: String, displayName: String, client: ClientUser) {
        super.init(userId: userId, displayName: displayName)
        self.client = client
    }
    /// init user from Firebase
    required init(from decoder: Decoder) throws {
        #warning("This isn't tested")
        try super.init(from: decoder)
    }
}
