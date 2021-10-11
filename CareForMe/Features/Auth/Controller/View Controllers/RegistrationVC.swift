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

class RegistrationViewController: UIViewController, AuthControllable {
    
    var userType: UserType
    
    private let authService = AuthService.shared
    lazy var authDelegate = AuthDelegate(self)
    
    private lazy var registrationView = AuthView(delegate: authDelegate)
    private var completionClosure: () -> Void
    
    init(userType: UserType, completionClosure: @escaping () -> Void) {
        self.userType = userType
        self.completionClosure = completionClosure
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    override func loadView() {
        self.view = registrationView
    }
    
}

extension RegistrationViewController: RegistrationProcessable {
    func processRegistration(email: String, password: String) {
        guard let emailAddress = registrationView.emailAddress else { return }
        authService.registerWithEmail(userType: userType, emailInput: emailAddress, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                UserDefaultsConfig.hasOnboarded = true
            case .failure:
                return
            }
            self.dismiss(animated: false) {
                self.completionClosure()
            }
        }
    }
}
