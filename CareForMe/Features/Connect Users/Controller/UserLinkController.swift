//
//  UserLinkController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/9/21.
//

import Foundation

class UserLinkController {
    private let dbController = FirebaseDatabaseController()
    private let user = AuthService.shared.user
    
    func getLinkFromAPI(completion: @escaping () -> Void) {
        guard let user = user else { return }
        dbController.observe(endpoint: .userLinkRef(userId: user.privateDetails.userId)) { snapshot in
            guard snapshot.exists() else { return }
            defer { completion() }
            do {
                let userLink = try snapshot.data(as: UserLink.self)
                user.privateDetails.linkedUser = userLink
            } catch {
                print(error)
            }
        }
    }
}
