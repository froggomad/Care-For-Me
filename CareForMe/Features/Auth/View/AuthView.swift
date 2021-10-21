//
//  LoginView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/5/21.
//

import UIKit

class AuthView: UIView {
    
    weak var delegate: AuthProcessable?
    private var passwordDelegate: PasswordStatusTextFieldDelegate?
    private var emailDelegate: EmailStatusTextFieldDelegate?
    
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
    
    private lazy var emailAddressTextField = StatusTextField<EmailStatusTextFieldDelegate>(textFieldType: .email, type: .information, exampleText: "Email Address", instructionText: "Please Enter an Email Address")
    
    private lazy var passwordTextField = StatusTextField<PasswordStatusTextFieldDelegate>(textFieldType: .secure, type: .information, exampleText: "Password", instructionText: "Please Enter a Password")
    
    private lazy var processAuthButton: UIButton = {
        let button: UIButton = .standardCFMButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(isLogin ? "Login" : "Register Account", for: .normal)
        button.addTarget(self, action: #selector(updateDelegate), for: .touchUpInside)
        return button
    }()
    
    init(delegate: AuthProcessable) {
        super.init(frame: .zero)
        self.delegate = delegate
        backgroundColor = .systemBackground
        self.passwordDelegate = PasswordStatusTextFieldDelegate(textFields: [passwordTextField])
        self.emailDelegate = EmailStatusTextFieldDelegate(textFields: [emailAddressTextField])
        self.emailAddressTextField.text = UserDefaultsConfig.lastLoggedInUsername
        
        if let savePasswordSetting = UserDefaultsConfig.savePasswords[AuthService.shared.user?.privateDetails.userId ?? ""],
           let setting = savePasswordSetting {
            if setting {
                let credentialResult = KeychainOperator.retrieveSignInInfo(for: emailAddressTextField.text ?? "")
                switch credentialResult {
                case let .success(info):
                    passwordTextField.text = info.password
                case let .failure(error):
                    print(error)
                }
            }
        }
        subViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func subViews() {
        addSubview(mainStack)
        addSubview(processAuthButton)
        constraints()
    }
    
    private func constraints() {
        let spacing: CGFloat = 40
        NSLayoutConstraint.activate([
            mainStack.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            mainStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            mainStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            
            processAuthButton.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: spacing),
            processAuthButton.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            processAuthButton.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor)
        ])
    }
    
    @objc private func updateDelegate() {
        guard let emailAddress = emailAddress,
              let password = password,
              let delegate = delegate
        else { return }
        
        UserDefaultsConfig.lastLoggedInUsername = emailAddress
        setPassword(emailAddress, password)
        
        guard let loginDelegate = delegate.loginDelegate else {
            delegate.registrationDelegate?.processRegistration(email: emailAddress, password: password)
            return
        }
        
        loginDelegate.processLogin(email: emailAddress, password: password)
    }
    
    private func setPassword(_ emailAddress: String, _ password: String) {
        if let savePasswordSetting = UserDefaultsConfig.savePasswords[AuthService.shared.user?.privateDetails.userId ?? ""],
           let setting = savePasswordSetting {
            if setting {
                KeychainOperator.setPassword(for: emailAddress, with: password)
            }
        } else {
            // TODO: alert user, ask if they want to save password
            // maybe delegate of delegate can handle
        }
    }
    
}
