//
//  LoginVC.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/5/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let authService = AuthService.shared
    
    private lazy var loginView: AuthView = {
        var loginView = AuthView(type: .login, delegate: AuthDelegate(self))
        return loginView
    }()
    
    override func loadView() {
        self.view = loginView
    }
    
}

extension LoginViewController: LoginProcessable {
    
    func processLogin(email: String, password: String) {
        guard let emailAddress = loginView.emailAddress,
              let password = loginView.password else { return }
        authService.loginWithEmail(emailAddress, password: password) { result in
            print(result)
        }
    }
}
