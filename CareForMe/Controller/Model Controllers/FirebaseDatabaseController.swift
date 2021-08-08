//
//  FirebaseDatabaseController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/22/21.
//

import FirebaseDatabase
import FirebaseDatabaseSwift

class FirebaseDatabaseController {
    static let db = Database.database().reference()
    
    /// Create a new database entry with an auto-created ID
    /// - Parameters:
    ///   - childRef: The path to the database entry
    ///   - value: a Codable instance used to set keys and values
    func createReferenceWithId<T: Codable>(for childRef: APIRef, using value: T, completion: @escaping (Error?) -> Void) {
        do {
            try Self.db.child(childRef.endpoint).childByAutoId().setValue(from: value, completion: completion)
        } catch {
            completion(error)
        }
    }
    
    func setValue<T: Encodable>(for ref: APIRef, with value: T) {
        try? Self.db.child(ref.endpoint).setValue(from: value)
    }
    
    func updateValues(for ref: APIRef, with dictionary: [String: Encodable]) {
        Self.db.child(ref.endpoint).updateChildValues(dictionary)
    }
    
    func observe(endpoint: APIRef, event: DataEventType = .childAdded, completion: @escaping (DataSnapshot) -> Void) {
        let ref = Self.db.child(endpoint.endpoint)
        ref.observe(event, with: completion)
    }
    
}

enum APIRef {
    case userRef(userId: String)
    case userNotifications(userId: String)
    case userReadNotifications(userId: String)
    case userUnreadNotifications(userId: String)
    case postUnreadNotification(userId: String, notificationId: String)
    case postReadNotification(userId: String, notificationId: String)
    case userLink
    
    var endpoint: String {
        switch self {
        case let .userRef(userId):
            return userRefEndpoint(userId: userId)
        case let .userNotifications(userId):
            return self.userNotificationsEndpoint(userId: userId)
        case let .userReadNotifications(userId):
            return self.userNotificationsEndpoint(userId: userId) + "read/"
        case let .userUnreadNotifications(userId):
            return self.userNotificationsEndpoint(userId: userId) + "unread/"
        case .userLink:
            return "/users/toLink"
        case let .postUnreadNotification(userId, notificationId):
            return Self.userUnreadNotifications(userId: userId).endpoint + notificationId
        case let .postReadNotification(userId, notificationId):
            return Self.userReadNotifications(userId: userId).endpoint + notificationId
        }
    }
    
    private func userRefEndpoint(userId: String) -> String {
        return "/users/\(userId)/"
    }
    
    private func userNotificationsEndpoint(userId: String) -> String {
        return userRefEndpoint(userId: userId) + "notifications/"
    }
}
