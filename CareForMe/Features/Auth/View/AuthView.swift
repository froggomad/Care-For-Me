//
//  LoginView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/5/21.
//

import UIKit

class AuthView: UIView {
    
    weak var delegate: AuthProcessable?
    var passwordDelegate: PasswordStatusTextFieldDelegate?
    var emailDelegate: EmailStatusTextFieldDelegate?
    
    private var isLogin: Bool {
        delegate?.loginDelegate != nil
    }
    
    private var isRegistration: Bool {
        delegate?.registrationDelegate != nil
    }
    
    var emailAddress: String? {
        emailAddressTextField.text
    }
    
    var password: String? {
        passwordTextField.text
    }
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textFieldStack])
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
        let button: UIButton = .fullWidthButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(isLogin ? "Login" : "Registration", for: .normal)
        button.addTarget(self, action: #selector(updateDelegate), for: .touchUpInside)
        return button
    }()
    
    init(delegate: AuthProcessable) {
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
        addSubview(processAuthButton)
        
        NSLayoutConstraint.activate([
            mainStack.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            mainStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            mainStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),
            
            processAuthButton.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 40),
            processAuthButton.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            processAuthButton.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor)
        ])
        
    }
    
    @objc private func updateDelegate() {
        guard let emailAddress = emailAddress,
              let password = password,
              let delegate = delegate
        else { return }
        guard let loginDelegate = delegate.loginDelegate else {
            delegate.registrationDelegate?.processRegistration(email: emailAddress, password: password)
            return
        }
        
        loginDelegate.processLogin(email: emailAddress, password: password)
    }
    
}
