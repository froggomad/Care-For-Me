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
        var loginView = AuthView(type: .login, delegate: self)
        return loginView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        self.view = loginView
    }
    
}

extension LoginViewController: AuthProcessable {
    func processRegistration(email: String, password: String) {
        guard let emailAddress = loginView.emailAddress,
              let password = loginView.password else { return }
        authService.registerWithEmail(emailInput: emailAddress, password: password) { result in
            print(result)
        }
    }
    
    func processLogin(email: String, password: String) {
        guard let emailAddress = loginView.emailAddress,
              let password = loginView.password else { return }
        authService.loginWithEmail(emailAddress, password: password) { result in
            print(result)
        }
    }
}
