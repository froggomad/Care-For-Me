//
//  RegistrationVC.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/3/21.
//

import UIKit

protocol RegistrationProcessable: AnyObject {
    func processRegistration(email: String, password: String)
}

class RegistrationViewController: UIViewController {
    
    private let authService = AuthService.shared
    private lazy var authDelegate = AuthDelegate(self)
    
    private lazy var registrationView = AuthView(delegate: authDelegate)
    
    override func loadView() {
        self.view = registrationView
    }
    
}

extension RegistrationViewController: RegistrationProcessable {
    func processRegistration(email: String, password: String) {
        guard let emailAddress = registrationView.emailAddress else { return }
        authService.registerWithEmail(emailInput: emailAddress, password: "12345678") { result in
            print(result)
        }
    }
}


