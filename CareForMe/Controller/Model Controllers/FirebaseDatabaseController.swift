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
    
}

struct APIRef {
    static func userNotifications(userId: String) -> String {
        "/users/\(userId)/notifications/"
    }
    
    static func userRef(userId: String) -> String {
        "/users/\(userId)"
    }
}
