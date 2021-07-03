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
    
    func setValue<T: Codable>(for ref: String, with value: T) {
        FirebaseDatabaseController.db.child(ref).setValue(value)
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
            return userRef(userId: userId)
        case let .userNotifications(userId):
            return self.userNotifications(userId: userId)
        case let .userReadNotifications(userId):
            return self.userNotifications(userId: userId) + "read"
        case let .userUnreadNotifications(userId):
            return self.userNotifications(userId: userId) + "unread/"
        }
    }
    
    private func userRef(userId: String) -> String {
        return "/users/\(userId)/"
    }
    
    private func userNotifications(userId: String) -> String {
        return userRef(userId: userId) + "notifications/"
    }
}
