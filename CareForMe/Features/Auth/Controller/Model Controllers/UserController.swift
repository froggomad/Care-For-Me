//
//  UserController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/8/21.
//

import Foundation
import UIKit

class UserController {
    let user = AuthService.shared.user
    let db = FirebaseDatabaseController()
    
    init() {
        getUserDetails()
    }
    
    func getUserDetails() {
        getPublicUserDetails()
        getPrivateUserDetails()
    }
    
    private func getPublicUserDetails(completion: @escaping () -> Void = { }) {
        guard let user = AuthService.shared.user else { return }
        db.observe(ref: .publicDetailsRef(userId: user.privateDetails.userId)) { snapshot in
            defer { completion() }
            guard snapshot.exists() else { return }
            
            do {
                let data = try snapshot.data(as: PublicUserDetails.self)
                user.publicDetails = data
            } catch {
                print("error converting publicDetails: \(error)")
            }
            
        }
    }
    
    private func getPrivateUserDetails(completion: @escaping () -> Void = { }) {
        JoinUsersController.getLinkFromAPI() { [weak self] in
            self?.getJoinRequests() {
                completion()
            }
        }
    }
    
    private func getJoinRequests(completion: @escaping () -> Void) {
        guard let user = user else { return }
        db.observe(ref: .joinRequests(userId: user.privateDetails.userId)) { snapshot in
            defer {
                NotificationCenter.default.post(name: .joinRequestChanged, object: nil)
                completion()
            }
            
            guard snapshot.exists() else {
                user.privateDetails.joinRequests = nil
                return
            }
            do {
                let snapshotData = try snapshot.data(as: [String: JoinRequest].self)
                let joinRequests = Array(snapshotData.values)
                user.privateDetails.joinRequests = joinRequests
            } catch {
                print(error)
            }
        }
    }
}

extension Notification.Name {
    static let joinRequestChanged = Notification.Name(rawValue: "joinRequestChanged")
}
