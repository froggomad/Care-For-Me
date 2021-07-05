//
//  User.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/30/21.
//

import Foundation

class CareUser: Codable {
    
    let userId: String
    let displayName: String
    weak var companion: CareUser?
    
    init(userId: String, displayName: String, companion: CareUser? = nil) {
        self.userId = userId
        self.displayName = displayName
        self.companion = companion
    }
    
}
