//
//  StatusTextFieldView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/20/21.
//

import UIKit

enum StatusType {
    case information
    case error(StatusErrorable)
}

enum TextFieldType {
    case empty
    case secure
    case email
}

class StatusTextFieldView: UIView {
    
    // MARK: - Properties -
    weak var delegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = self.delegate
        }
    }
    
    var type: StatusType {
        didSet {
            setupLabels(by: type)
        }
    }
    
    var textFieldType: TextFieldType {
        didSet {
            setupTextField()
        }
    }
    
    
    let exampleText: String?
    let textFieldPlaceholderText: String?
    let instructionText: String?
    // MARK: - Views -
    lazy var parentStack: UIStackView = .componentStack(elements: [exampleLabel,textField,instructionLabel], distribution: .fill, horizontalAlignment: .leading)
    
    lazy var exampleLabel: UILabel = .captionLabel(text: exampleText)
    lazy var textField: UITextField = .borderedTextField(placeholderText: textFieldPlaceholderText)
    lazy var instructionLabel: UILabel = .captionLabel(text: instructionText)
    
    init(textFieldType: TextFieldType, type: StatusType, exampleText: String? = nil, textFieldPlaceholderText: String? = nil, instructionText: String? = nil) {
        
        self.exampleText = exampleText
        self.textFieldPlaceholderText = textFieldPlaceholderText
        self.instructionText = instructionText
        self.type = type
        self.textFieldType = textFieldType
        super.init(frame: .zero)
        setupLabels(by: type)
        setupViews()
    }
    
    private func setupLabels(by type: StatusType) {
        switch type {
        case .information:
            exampleLabel.textColor = .label
            instructionLabel.textColor = .label
        case .error:
            exampleLabel.textColor = .systemRed
            instructionLabel.textColor = .systemRed
        }
    }
    // MARK: - View Lifecycle -
    private func setupViews() {
        setupTextField()
        addSubview(parentStack)
        constraints()
    }
    
    private func constraints() {
        parentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            parentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            parentStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            parentStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            parentStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    private func setupTextField() {
        switch textFieldType {
        case .email:
            textField.keyboardType = .emailAddress
            textField.textContentType = .emailAddress
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        case .secure:
            textField.textContentType = .password
            textField.isSecureTextEntry = true
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        case .empty:
            textField.textContentType = .name
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .yes
        }
    }
    
    func displayErrorMessage(for error: StatusErrorable) {
        self.type = .error(error)
        exampleLabel.text = error.message
        instructionLabel.text = error.instructions
    }
    
    func displayStatusMessage() {
        self.type = .information
        exampleLabel.text = exampleText
        instructionLabel.text = instructionText
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
}
