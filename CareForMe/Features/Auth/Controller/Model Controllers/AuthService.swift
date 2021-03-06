//
//  UserController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/30/21.
//

// NOTE: Not importing FirebaseAuth due to intermittent issues with `AuthDataResult` not found
import Firebase

class AuthService {
    enum AuthError: Error {
        case emailValidation
        case passwordValidation
        case firebaseAuthError
    }
    
    private let dbController = FirebaseDatabaseController()
    var user: CareUser?
    
    var isLoggedIn: Bool {
        Auth.auth().currentUser != nil && user != nil
    }
    
    // MARK: - Singleton -
    static let shared = AuthService()
    private init() {
        listenForAuthStateChanges()
    }
    
    func listenForAuthStateChanges() {
       Auth.auth().addStateDidChangeListener { _, user in
        DispatchQueue.main.async {
             if user != nil {
                NotificationCenter.default.post(name: .userLoggedIn, object: nil)
             } else {
                NotificationCenter.default.post(name: .userLoggedOut, object: nil)
             }
        }
       }
   }
    
    func registerWithEmail(userType: UserType, emailInput: String, password: String, completion: @escaping (Result<AuthDataResult?, AuthError>) -> Void) {
        
        var emailValidation = EmailAuth(email: emailInput)
        
        switch emailValidation.emailOutput {
        
        case .failure:
            completion(.failure(.emailValidation))
            
        case let .success(email):
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }
                
                if error != nil {
                    completion(.failure(.firebaseAuthError))
                    return
                }
                
                if let user = authResult?.user {
                    
                    if userType == .client {
                        let client = ClientUser(userId: user.uid, displayName: user.displayName ?? "Anonymous Client")
                        self.user = client
                        self.dbController.setUserValue(for: .userRef(userId: client.privateDetails.userId), with: client)
                    } else if userType == .caregiver {
                        let caregiver = CaregiverUser(userId: user.uid, displayName: user.displayName ?? "Anonymous Caregiver")
                        self.user = caregiver
                        self.dbController.setUserValue(for: .userRef(userId: caregiver.privateDetails.userId), with: caregiver)
                    }
                    
                    completion(.success(authResult))
                    
                } else { completion(.failure(.firebaseAuthError)) }
            }
        }
        
    }
    
    func loginWithEmail(_ email: String, password: String, completion: @escaping (Result<AuthDataResult?, AuthError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if error != nil {
                completion(.failure(.firebaseAuthError))
                return
            }
            
            if let user = authResult?.user {
                let careUser = CareUser(authUser: user)
                self.user = careUser
                completion(.success(authResult))
            } else { completion(.failure(.firebaseAuthError)) }
            
        }
    }
    
    /// preferred registration method
    func registerWithPhone() {
        
    }
    
    func loginWithEmail() {
        
    }
    
    func loginWithPhone() {
        
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
    
}

struct EmailAuth {
    enum Error: Swift.Error {
        case invalidEmail
    }
    
    @EmailInput
    private var email: String?
    
    lazy var emailOutput: Result<String, Error> = {
        guard let email = email else {
            return .failure(Error.invalidEmail)
        }
        return .success(email)
    }()
    
    init(email: String) {
        self.email = email
    }
}

@propertyWrapper
class EmailInput {
    
    private var value: String?
    
    var wrappedValue: String? {
        get {
            return value
        }
        set {
            value = {
                guard let trimmedString = newValue?.trimmingCharacters(in: .whitespacesAndNewlines) else { return  nil }
                return validate(trimmedString)
            }()
        }
    }
    
    private func validate(_ emailString: String) -> String? {
        let dataDetector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        // Finding matches in string
        let range = NSRange(emailString.startIndex..<emailString.endIndex, in: emailString)
        guard let match = dataDetector.firstMatch(in: emailString, options: .anchored, range: range) else { return nil }
        guard let url = match.url else { return nil }
        
        // Extracting email from the matched url
        let absoluteString = url.absoluteString
        guard let index = absoluteString.range(of: "mailto:") else { return nil }
        return String(url.absoluteString.suffix(from: index.upperBound))
    }
}

extension Notification.Name {
    static var userLoggedOut: Notification.Name {
        .init("loggedOut")
    }
    
    static var userLoggedIn: Notification.Name {
        .init("loggedIn")
    }
}
