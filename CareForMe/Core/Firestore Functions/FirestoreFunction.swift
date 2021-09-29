//
//  FirestoreFunction.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 9/25/21.
//
import FirebaseFunctions

enum FirestoreFunction {
    
    case generateJoinCode(userId: String, joincode: String, userType: String)
    
    /// The name of the Firebase Function (must equate to the name in Firebase)
    private var name: String {
        switch self {
        case .generateJoinCode:
            return "generateCode"
        }
    }
    /// - Used to send data to the Firebase Function
    private var parameters: [String: Any]? {
        
        switch self {
        case .generateJoinCode(let userId, let joinCode, let userType):
            return ["userId": userId, "joinCode": joinCode, "userType": userType]
        }
    }
    
    func call(completion: @escaping (HTTPSCallableResult?, Error?) -> Void)  {
        let function = self
        Functions.functions().httpsCallable(function.name)
            .call(function.parameters, completion: completion)
    }
}
