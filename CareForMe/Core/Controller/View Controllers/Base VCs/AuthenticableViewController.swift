//
//  AuthenticableViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/7/21.
//

import UIKit

protocol AuthenticableViewController: UIViewController {
    var isAuthenticated: Bool { get }
    func authenticate()
}

extension AuthenticableViewController {
    var isAuthenticated: Bool {
        AuthService.shared.isLoggedIn
    }
    
    func authenticate() {
        if !isAuthenticated {
            let vc = AuthViewController(authType: .login)
            present(vc, animated: true)
        }
    }
}

class AuthenticatedViewController: UIViewController, AuthenticableViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        authenticate()
    }
    
}
