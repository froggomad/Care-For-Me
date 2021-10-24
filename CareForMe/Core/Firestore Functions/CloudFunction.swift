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
    
    func call(completion: @escaping (HTTPSCallableResult?, Error?) -> Void)  {
        let function = self
        Functions.functions().httpsCallable(function.name)
            .call(function.parameters, completion: completion)
    }
    
}
