//
//  LoginVC.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/5/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let authService = AuthService.shared
    
    private lazy var loginView: LoginView = {
        var loginView = LoginView(delegate: self)
        return loginView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        self.view = loginView
    }
    
}

extension LoginViewController: LoginProcessable {
    func processLogin(email: String, password: String) {
        guard let emailAddress = loginView.emailAddress else { return }
        authService.loginWithEmail(emailAddress, password: "12345678") { result in
            print(result)
        }
    }
}
