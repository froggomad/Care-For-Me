//
//  User.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/30/21.
//

import Foundation
import Firebase

enum UserType: String, Codable, CaseIterable {
    case client
    case caregiver
}

struct PublicUserDetails: Codable {
    let userType: UserType
    let displayName: String
}

struct PrivateUserDetails: Codable {
    let userId: String
    var joinRequests: [JoinRequest]?
    var linkedUser: UserLink?
}

class CareUser: Codable {
    
    var privateDetails: PrivateUserDetails
    let publicDetails: PublicUserDetails
    
    convenience init(authUser: User) {
        self.init(userId: authUser.uid, displayName: authUser.displayName ?? "Anonymous", userType: .client)
    }
    
    init(userId: String, displayName: String, userType: UserType) {
        self.privateDetails = PrivateUserDetails(userId: userId)
        self.publicDetails = PublicUserDetails(userType: userType, displayName: displayName)
    }
    
}

class ClientUser: CareUser {
    weak var caregiver: CaregiverUser?
    /// init user without caregiver
    required override init(userId: String, displayName: String, userType: UserType = .client) {
        super.init(userId: userId, displayName: displayName, userType: userType)
    }
    /// init user with caregiver
    required init(userId: String, displayName: String, caregiver: CaregiverUser) {
        super.init(userId: userId, displayName: displayName, userType: .client)
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
    required override init(userId: String, displayName: String, userType: UserType = .caregiver) {
        super.init(userId: userId, displayName: displayName, userType: userType)
    }
    /// init user with client
    required init(userId: String, displayName: String, client: ClientUser) {
        super.init(userId: userId, displayName: displayName, userType: .caregiver)
        self.client = client
    }
    /// init user from Firebase
    required init(from decoder: Decoder) throws {
        #warning("This isn't tested")
        try super.init(from: decoder)
    }
}
