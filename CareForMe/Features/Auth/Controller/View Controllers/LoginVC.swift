//
//  LoginVC.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/5/21.
//

import UIKit

protocol LoginProcessable: AnyObject {
    func processLogin(email: String, password: String)
}

class LoginViewController: UIViewController {
    
    private let authService = AuthService.shared
    private lazy var authDelegate = AuthDelegate(self)
    
    private lazy var loginView: AuthView =  AuthView(delegate: authDelegate)
    
    override func loadView() {
        self.view = loginView
    }
    
    private func presentTabBar() {
        let tbc = TabBar.createMainTabBar()
        tbc.modalTransitionStyle = .flipHorizontal
        tbc.modalPresentationStyle = .fullScreen
        self.present(tbc, animated: true)
    }
    
}

extension LoginViewController: LoginProcessable {
    
    func processLogin(email: String, password: String) {
        guard let emailAddress = loginView.emailAddress,
              let password = loginView.password else { return }
        authService.loginWithEmail(emailAddress, password: password) { result in
            switch result {
            case .success:
                self.presentTabBar()
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
