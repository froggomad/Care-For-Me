//
//  LoginView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/5/21.
//

import UIKit

enum AuthType {
    case registration
    case login
}

typealias AuthProcessable = LoginProcessable & RegistrationProcessable

protocol LoginProcessable: AnyObject {
    func processLogin(email: String, password: String)
}

class AuthView: UIView {
    
    var type: AuthType
    weak var delegate: AuthProcessable?
    var passwordDelegate: PasswordStatusTextFieldDelegate?
    var emailDelegate: EmailStatusTextFieldDelegate?
    
    var emailAddress: String? {
        emailAddressTextField.text
    }
    
    var password: String? {
        passwordTextField.text
    }
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textFieldStack, processAuthButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
        
    private lazy var textFieldStack: UIStackView = .componentStack(elements: [emailAddressTextField, passwordTextField])
    
    private lazy var emailAddressTextField = StatusTextField<EmailStatusTextFieldDelegate>(type: .information, exampleText: "Email Address", instructionText: "Please Enter an Email Address")
    
    private lazy var passwordTextField = StatusTextField<PasswordStatusTextFieldDelegate>(type: .information, exampleText: "Password", instructionText: "Please Enter a Password")
    
    private lazy var processAuthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(type == .login ? "Login" : "Registration", for: .normal)
        button.addTarget(self, action: #selector(updateDelegate), for: .touchUpInside)
        return button
    }()
    
    init(type: AuthType, delegate: AuthProcessable) {
        self.type = type
        super.init(frame: .zero)
        self.delegate = delegate
        backgroundColor = .systemBackground
        self.passwordDelegate = PasswordStatusTextFieldDelegate(textFields: [passwordTextField])
        self.emailDelegate = EmailStatusTextFieldDelegate(textFields: [emailAddressTextField])
        subViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func subViews() {
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            mainStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            mainStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40)
        ])
        
    }
    
    @objc private func updateDelegate() {
        guard let emailAddress = emailAddress,
              let password = password
        else { return }
        
        switch type {
        case .login:
            delegate?.processLogin(email: emailAddress, password: password)
        case .registration:
            delegate?.processRegistration(email: emailAddress, password: password)
            
        }
    }
    
}
