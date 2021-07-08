//
//  RegistrationView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/5/21.
//

import UIKit

protocol RegistrationProcessable: AnyObject {
    func processRegistration(email: String, password: String)
}

class RegistrationView: UIView {
    
    weak var delegate: RegistrationProcessable?
    
    var emailAddress: String? {
        emailAddressTextField.text
    }
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailAddressStack, registerButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
        
    private lazy var emailAddressStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailLabel, emailAddressTextField])
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .center
        return stack
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email Address:"
        return label
    }()
    
    private lazy var emailAddressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Tap To Enter Email Address"
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(updateDelegate), for: .touchUpInside)
        return button
    }()
    
    private func subViews() {
        addSubview(mainStack)
        
        let height: CGFloat = 100
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -height/2),
            mainStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            mainStack.heightAnchor.constraint(equalToConstant: height),
            mainStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40)
        ])
        
    }
    
    @objc private func updateDelegate() {
        guard let emailAddress = emailAddress else { return }
        delegate?.processRegistration(email: emailAddress, password: "12345678")
    }
    
    init(delegate: RegistrationProcessable) {
        super.init(frame: .zero)
        self.delegate = delegate
        backgroundColor = .systemBackground
        subViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
}
