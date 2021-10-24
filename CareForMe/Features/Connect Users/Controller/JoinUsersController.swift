//
//  UserLinkController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/9/21.
//

import Foundation

class JoinUsersController {
    private static let dbController = FirebaseDatabaseController()
    private static let user = AuthService.shared.user
    
    static func generateJoinCode(userId: String, joinCode: String, userType: UserType, completion: @escaping (Result<UserLink, Error>) -> Void) {
        CloudFunction.generateJoinCode(userId: userId, joinCode: joinCode, userType: userType)
            .call { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = result?.data as? [String:String] else {
                    print("couldn't convert data to UserLink")
                    completion(.failure(CloudFunction.CloudFunctionError.badResponse))
                    return
                }
                let userLink = UserLink(from: data)
                completion(.success(userLink))
            }
    }
    
    static func getLinkFromAPI(completion: @escaping () -> Void) {
        guard let user = user else { return }
        dbController.observe(ref: .userLinkRef(userId: user.privateDetails.userId)) { snapshot in
            defer { completion() }
            guard snapshot.exists() else { return }
            do {
                let userLink = try snapshot.data(as: UserLink.self)
                user.privateDetails.linkedUser = userLink
            } catch {
                print(error)
            }
        }
    }
    
    static func joinRequest(userId: String, joinCode: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        CloudFunction.linkRequest(userId: userId, joinCode: joinCode)
            .call { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let data = result?.data as? Bool
                completion(.success(data ?? false))
            }
    }
    
    static func denyJoinRequest(userId: String, joinCode: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        CloudFunction.denyLinkRequest(userId: userId, joinCode: joinCode)
            .call { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let data = result?.data as? Bool ?? false
                completion(.success(data))
            }
    }
    
    static func acceptJoinRequest(userId: String, joinCode: String, userType: UserType, completion: @escaping (Result<JoinRequestResponse, Error>) -> Void) {
        CloudFunction.acceptLinkRequest(userId: userId, joinCode: joinCode, userType: userType)
            .call { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let data = result?.data as? [String: Any]
                
                if let acceptedField = data?["accepted"] as? Bool,
                   acceptedField == false {
                    completion(.failure(CloudFunction.CloudFunctionError.declined))
                } else {
                    guard let requestingUserType = data?["requestingUserType"] as? String,
                          let joinCode = data?["code"] as? String,
                          let requestingUserId = data?["requestingUserId"] as? String else {
                              completion(.failure(CloudFunction.CloudFunctionError.badResponse))
                              return
                          }
                    
                    let joinRequestResponse = JoinRequestResponse(code: joinCode, requestingUserType: requestingUserType, requestingUserId: requestingUserId)
                    completion(.success(joinRequestResponse))
                }
            }
    }
}
