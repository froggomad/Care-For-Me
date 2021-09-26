//
//  FirebaseDatabaseController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/22/21.
//

import FirebaseDatabase
import FirebaseDatabaseSwift

class FirebaseDatabaseController {
    private static let db = Database.database().reference()
    
    /// Create a new database entry with an auto-created ID
    /// - Parameters:
    ///   - childRef: The path to the database entry
    ///   - value: a Codable instance used to set keys and values
    func createReferenceWithId<T: Codable>(for childRef: NotificationAPIRef, using value: T, completion: @escaping (Error?) -> Void) {
        do {
            try Self.db.child(childRef.endpoint).childByAutoId().setValue(from: value, completion: completion)
        } catch {
            completion(error)
        }
    }
    
    func setUserValue<T: Encodable>(for ref: UserDatabaseAPIRef, with value: T) {
        try? Self.db.child(ref.endpoint).setValue(from: value)
    }
    
    func setNotificationValue<T: Encodable>(for ref: NotificationAPIRef, with value: T) {
        try? Self.db.child(ref.endpoint).setValue(from: value)
    }
    
    func updateValues(for ref: UserDatabaseAPIRef, with dictionary: [String: Encodable]) {
        Self.db.child(ref.endpoint).updateChildValues(dictionary)
    }
    
    func observe(endpoint: NotificationAPIRef, event: DataEventType = .childAdded, completion: @escaping (DataSnapshot) -> Void) {
        let ref = Self.db.child(endpoint.endpoint)
        ref.observe(event, with: completion)
    }
    
}

enum UserDatabaseAPIRef {
    case userRef(userId: String)
    case tokenRef(userId: String)
    case userLinkRef
    
    var endpoint: String {
        switch self {
        case let .userRef(userId):
            return Self.userRefEndpoint(userId: userId)
        case let .tokenRef(userId):
            return Self.privateUserDetails(userId: userId)
        case .userLinkRef:
            return "/users/toLink"
        }
    }
    
    static func userRefEndpoint(userId: String) -> String {
        return "/users/\(userId)/"
    }
    
    static func privateUserDetails(userId: String) -> String {
        return userRefEndpoint(userId: userId) + "privateDetails"
    }
}

enum NotificationAPIRef {
    
    case userNotifications(userId: String)
    case userReadNotifications(userId: String)
    case userUnreadNotifications(userId: String)
    case postUnreadNotification(userId: String, notificationId: String)
    case postReadNotification(userId: String, notificationId: String)
    
    var endpoint: String {
        switch self {
        case let .userNotifications(userId):
            return self.userNotificationsEndpoint(userId: userId)
        case let .userReadNotifications(userId):
            return self.userNotificationsEndpoint(userId: userId) + "read/"
        case let .userUnreadNotifications(userId):
            return self.userNotificationsEndpoint(userId: userId) + "unread/"
        case let .postUnreadNotification(userId, notificationId):
            return Self.userUnreadNotifications(userId: userId).endpoint + notificationId
        case let .postReadNotification(userId, notificationId):
            return Self.userReadNotifications(userId: userId).endpoint + notificationId
        }
    }
    
    private func userNotificationsEndpoint(userId: String) -> String {
        return UserDatabaseAPIRef.userRefEndpoint(userId: userId) + "notifications/"
    }
}
