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
        getJoinRequests()
        linkController.getLinkFromAPI()
    }
    
    private func getJoinRequests() {
        guard let user = user else { return }
        db.observe(endpoint: .joinRequests(userId: user.privateDetails.userId), event: .value) { snapshot in
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
