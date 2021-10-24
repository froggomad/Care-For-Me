//
//  JoinRequestAcceptResponse.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/6/21.
//

import Foundation

struct JoinRequestResponse {
    let joinCode: String
    let requestingUserType: UserType
    let requestingUserId: String
    
    init(code: String, requestingUserType: String, requestingUserId: String) {
        self.joinCode = code
        let userType = UserType(rawValue: requestingUserType) ?? .client
        self.requestingUserType = userType
        self.requestingUserId = requestingUserId
    }
}
