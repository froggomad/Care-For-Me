//
//  RegistrationVC.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/3/21.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    private let authService = AuthService.shared
    
    private lazy var registrationView: RegistrationView = {
        var registrationView = RegistrationView(registrationSelector: #selector(registerTapped(_:)))
        return registrationView
    }()
    
    
    @objc private func registerTapped(_ sender: UIButton) {
        guard let emailAddress = registrationView.emailAddress else { return }
        authService.registerWithEmail(emailInput: emailAddress, password: "12345678") { result in
            print(result)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        self.view = registrationView
    }
}
