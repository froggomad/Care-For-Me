//
//  FirestoreFunction.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 9/25/21.
//
import FirebaseFunctions
import UIKit

enum CloudFunction {
    
    enum CloudFunctionError: Error {
        case wrongCall
        case declined
        case badResponse
    }
    
    case generateJoinCode(userId: String, joinCode: String, userType: UserType)
    case linkRequest(userId: String, joinCode: String)
    case acceptLinkRequest(userId: String, joinCode: String, userType: UserType)
    case denyLinkRequest(userId: String, joinCode: String)
    
    /// The name of the Firebase Function (must equate to the name in Firebase)
    private var name: String {
        switch self {
        case .generateJoinCode:
            return "generateCode"
        case .linkRequest:
            return "linkRequest"
        case .acceptLinkRequest:
            return "acceptLinkRequest"
        case .denyLinkRequest:
            return "removeJoinRequest"
        }
    }
    /// - Used to send data to the Firebase Function
    private var parameters: [String: Any]? {
        switch self {
        case .generateJoinCode(let userId, let joinCode, let userType):
            return ["userId": userId, "joinCode": joinCode, "userType": userType.rawValue]
        case .linkRequest(let userId, let joinCode):
            return ["userId": userId, "joinCode": joinCode]
        case .acceptLinkRequest(userId: let userId, joinCode: let joinCode, userType: let userType):
            return ["userId": userId, "joinCode": joinCode, "userType": userType.rawValue]
        case .denyLinkRequest(userId: let userId, joinCode: let joinCode):
            return ["userId": userId, "requestId": joinCode]
        }
    }
    
    private func call(completion: @escaping (HTTPSCallableResult?, Error?) -> Void)  {
        let function = self
        Functions.functions().httpsCallable(function.name)
            .call(function.parameters, completion: completion)
    }
    
    func callGenerateJoinCode(completion: @escaping (Result<UserLink, Error>) -> Void) {
        call { result, error in
            switch self {
            case .generateJoinCode:
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = result?.data as? [String:String] else {
                    print("couldn't convert data to UserLink")
                    completion(.failure(CloudFunctionError.badResponse))
                    return
                }
                let userLink = UserLink(from: data)
                completion(.success(userLink))
            default: completion(.failure(CloudFunctionError.wrongCall))
            }
            
        }
    }
    
    func callLinkRequest(completion: @escaping (Result<Bool, Error>) -> Void) {
        switch self {
        case .linkRequest:
            call { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let data = result?.data as? Bool
                completion(.success(data ?? false))
            }
        default: completion(.failure(CloudFunctionError.wrongCall))
        }
    }
    
    func callRemoveJoinRequest(completion: @escaping (Result<Bool, Error>) -> Void) {
        switch self {
        case .denyLinkRequest:
            call { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let data = result?.data as? Bool ?? false
                completion(.success(data))
            }
        default: completion(.failure(CloudFunctionError.wrongCall))
        }
    }
    
    func callAcceptJoinRequest(completion: @escaping (Result<JoinRequestResponse, Error>) -> Void) {
        switch self {
        case .acceptLinkRequest:
            call { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let data = result?.data as? [String: Any]
                
                if let acceptedField = data?["accepted"] as? Bool,
                   acceptedField == false {
                    completion(.failure(CloudFunctionError.declined))
                } else {
                    guard let requestingUserType = data?["requestingUserType"] as? String,
                          let joinCode = data?["code"] as? String,
                          let requestingUserId = data?["requestingUserId"] as? String else {
                              completion(.failure(CloudFunctionError.badResponse))
                              return
                          }
                    
                    let joinRequestResponse = JoinRequestResponse(code: joinCode, requestingUserType: requestingUserType, requestingUserId: requestingUserId)
                    completion(.success(joinRequestResponse))
                }
            }
        default:
            completion(.failure(CloudFunctionError.wrongCall))
        }
    }
}
