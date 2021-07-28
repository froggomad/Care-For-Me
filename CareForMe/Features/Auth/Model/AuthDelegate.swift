//
//  AuthProcessable.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/28/21.
//

import Foundation

protocol AuthProcessable: AnyObject {
    var loginDelegate: LoginProcessable? { get }
    var registrationDelegate: RegistrationProcessable? { get }
    init(_ delegate: LoginProcessable)
    init(_ delegate: RegistrationProcessable)
}

class AuthDelegate: AuthProcessable {
    
    weak var loginDelegate: LoginProcessable?
    weak var registrationDelegate: RegistrationProcessable?
    
    required init(_ delegate: RegistrationProcessable) {
        self.registrationDelegate = delegate
    }
    
    required init(_ delegate: LoginProcessable) {
        self.loginDelegate = delegate
    }
}
