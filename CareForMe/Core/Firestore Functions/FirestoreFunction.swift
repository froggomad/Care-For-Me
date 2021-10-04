//
//  FirestoreFunction.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 9/25/21.
//
import FirebaseFunctions
import UIKit

enum FirestoreFunction {
    
    case generateJoinCode(userId: String, joinCode: String, userType: String)
    case linkRequest(userId: String, joinCode: String, userType: String)
    
    /// The name of the Firebase Function (must equate to the name in Firebase)
    private var name: String {
        switch self {
        case .generateJoinCode:
            return "generateCode"
        case .linkRequest:
            return "linkRequest"
        }
    }
    /// - Used to send data to the Firebase Function
    private var parameters: [String: Any]? {
        
        switch self {
        case .generateJoinCode(let userId, let joinCode, let userType):
            return ["userId": userId, "joinCode": joinCode, "userType": userType]
        case .linkRequest(let userId, let joinCode, let userType):
            return ["userId": userId, "joinCode": joinCode, "userType": userType]
        }
    }
    
    private func call(completion: @escaping (HTTPSCallableResult?, Error?) -> Void)  {
        let function = self
        Functions.functions().httpsCallable(function.name)
            .call(function.parameters, completion: completion)
    }
    
    func callGenerateJoinCode(completion: @escaping (Result<UserLink, Error>) -> Void) {
        call { result, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        let data = result?.data as? [String: String] ?? [:]
        let careGiverId = data["caregiver"]
        let clientId = data["client"]
        let expirationDateString = data["expiresOn"] ?? ""
        let joinCode = data["code"]
        
        let userLink = UserLink(caregiverId: careGiverId, clientId: clientId, joinCode: joinCode, expiresOn: DateFormatter.firebaseStringToDate(from: expirationDateString))
        completion(.success(userLink))
        }
    }
    
    func callLinkRequest(completion: @escaping (Result<Bool, Error>) -> Void) {
        call { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let data = result?.data as? Bool
            completion(.success(data ?? false))
        }
        
    }
}
