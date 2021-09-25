//
//  KeychainOperator.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/5/21.
//

import Security
import Foundation

class KeychainOperator {
    enum Error: Swift.Error {
        case noDataRetrieved
    }
    
    enum Server: String {
        case firebase = "com.google.firebase.kennydubroff.careforme"
    }
    
    @discardableResult static func setPassword(for username: String, with password: String, at server: String = Server.firebase.rawValue) -> OSStatus {
        let item = [
            kSecValueData: password.data(using: .utf8) ?? Data(),
            kSecAttrAccount: username,
            kSecAttrServer: server,
            kSecClass: kSecClassInternetPassword,
            kSecReturnData: false,
            kSecReturnAttributes: false
        ] as CFDictionary
        
        var ref: AnyObject?
        
        let status = SecItemAdd(item, &ref)
        
        if ref == nil {
            let passwordStatus = retrieveSignInInfo(for: username)
            var oldPassword: String
            
            switch passwordStatus {
            case let .success(signInInfo):
                oldPassword = signInInfo.password
            case .failure:
                oldPassword = ""
            }
            
            // password was likely already set
            updatePassword(for: username, with: oldPassword, using: password)
        }
        
        return status
    }
    
    static func retrieveSignInInfo(for username: String, at server: String = Server.firebase.rawValue) -> Result<UserSignInInfo, Error> {
        let query = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrAccount: username,
            kSecAttrServer: server,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        let _ = SecItemCopyMatching(query, &result)
        
        guard let userInfo = result as? NSDictionary,
              let username = userInfo[kSecAttrAccount] as? String,
              let passwordData = userInfo[kSecValueData] as? Data
        else { return .failure(.noDataRetrieved) }
        
        let signInInfo = UserSignInInfo(
            username: username,
            password: String(data: passwordData, encoding: .utf8) ?? ""
        )
        
        return .success(signInInfo)
    }
    
    static func updatePassword(for username: String, with oldPassword: String, at server: String = Server.firebase.rawValue, using newPassword: String) {
        let query = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrAccount: username,
            kSecAttrServer: server,
        ] as CFDictionary
        
        let updateFields = [
            kSecValueData: newPassword.data(using: .utf8)
        ] as CFDictionary
        
        let _ = SecItemUpdate(query, updateFields)
    }
    
    static func deleteUser(with username: String, at server: String) {
        let query = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrServer: server,
            kSecAttrAccount: username
        ] as CFDictionary
        
        SecItemDelete(query)
    }
}

struct UserSignInInfo {
    let username: String
    let password: String
}
