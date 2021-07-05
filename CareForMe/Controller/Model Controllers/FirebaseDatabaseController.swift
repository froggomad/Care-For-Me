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
    ///   - using: a Codable instance used to set keys and values
    func createReferenceWithId<T: Codable>(for childRef: String, using: T, completion: @escaping (Error?) -> Void) {
        do {
            try FirebaseDatabaseController.db.child(childRef).childByAutoId().setValue(from: using, completion: completion)
        } catch {
            completion(error)
        }
    }
    
    func setValue<T: Encodable>(for ref: String, with value: T) {
        try? FirebaseDatabaseController.db.child(ref).setValue(from: value)
    }
    
    func updateValues(for ref: String, with dictionary: [String: Encodable]) {
        FirebaseDatabaseController.db.child(ref).updateChildValues(dictionary)
    }
    
    func observe(endpoint: String, event: DataEventType = .childAdded, completion: @escaping (DataSnapshot) -> Void) {
        let ref = FirebaseDatabaseController.db.child(endpoint)
        ref.observe(event, with: completion)
    }
    
}

enum APIRef {
    case userRef(userId: String)
    case userNotifications(userId: String)
    case userReadNotifications(userId: String)
    case userUnreadNotifications(userId: String)
    
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
        }
    }
    
    private func userRefEndpoint(userId: String) -> String {
        return "/users/\(userId)/"
    }
    
    private func userNotificationsEndpoint(userId: String) -> String {
        return userRefEndpoint(userId: userId) + "notifications/"
    }
}
