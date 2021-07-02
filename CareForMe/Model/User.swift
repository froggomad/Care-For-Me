//
//  User.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/30/21.
//

import Foundation

struct User: Codable {
    let userId: UUID
    let notifications: [CareNotification]
}
