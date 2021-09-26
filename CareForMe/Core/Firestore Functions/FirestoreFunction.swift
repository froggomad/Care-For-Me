//
//  FirestoreFunction.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 9/25/21.
//
import FirebaseFunctions

enum FirestoreFunction {
    
    case saveJoinCode(userId: String, joincode: String)
    
    /// The name of the Firebase Function (must equate to the name in Firebase)
    private var name: String {
        switch self {
        case .saveJoinCode:
            return "saveCode"
        }
    }
    /// - Used to send data to the Firebase Function
    private var parameters: [String: Any]? {
        
        switch self {
        case .saveJoinCode(let userId, let joinCode):
            return ["userId": userId, "joinCode": joinCode]
        }
    }
    
    func call(completion: @escaping (HTTPSCallableResult?, Error?) -> Void)  {
        let function = self
        Functions.functions().httpsCallable(function.name)
            .call(function.parameters, completion: completion)
    }
}
