//
//  UserDefaultsWrapper.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/5/21.
//

import Foundation

enum UserDefaultKey: String {
    case hasOnboarded = "has_onboarded"
    case lastLoggedInUser = "last_logged_in_user"
    case savePasswords = "save_passwords"
}

@propertyWrapper
struct UserDefault<T> {
    let key: UserDefaultKey
    let defaultValue: T
    
    init(_ key: UserDefaultKey, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key.rawValue) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }
}

struct UserDefaultsConfig {
    
    @UserDefault(.hasOnboarded, defaultValue: [AuthService.shared.user?.userId ?? "": false])
    static var hasOnboarded: [String: Bool]
    
    @UserDefault(.lastLoggedInUser, defaultValue: "")
    static var lastLoggedInUsername: String
    
    @UserDefault(.savePasswords, defaultValue: [AuthService.shared.user?.userId ?? "": nil])
    static var savePasswords: [String: Bool?]
}
