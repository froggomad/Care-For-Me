//
//  RegistrationVC.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/3/21.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    private let authService = AuthService.shared
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailAddressStack, registerButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    
    private lazy var emailAddressStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailLabel, emailAddressTextField])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email Address:"
        return label
    }()
    
    private lazy var emailAddressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email Address"
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(registerTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc private func registerTapped(_ sender: UIButton) {
        guard let emailAddress = emailAddressTextField.text else { return }
        authService.registerWithEmail(emailInput: emailAddress, password: "12345678") { result in
            print(result)
        }
    }
    
    private func subViews() {
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        subViews()
    }
}
