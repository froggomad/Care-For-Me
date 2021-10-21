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
    let linkController = UserLinkController()
    let db = FirebaseDatabaseController()
    
    init() {
        getUserDetails()
    }
    
    func getUserDetails() {
        getPublicUserDetails()
        getPrivateUserDetails()
    }
    
    private func getPublicUserDetails() {
        
    }
    
    private func getPrivateUserDetails(completion: @escaping () -> Void = { }) {
        linkController.getLinkFromAPI() { [weak self] in
            self?.getJoinRequests() {
                completion()
            }
        }
    }
    
    private func getJoinRequests(completion: @escaping () -> Void) {
        guard let user = user else { return }
        db.observe(endpoint: .joinRequests(userId: user.privateDetails.userId)) { snapshot in
            guard snapshot.exists() else { return }
            defer { completion() }
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
