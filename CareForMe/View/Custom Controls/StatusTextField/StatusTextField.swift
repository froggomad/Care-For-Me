//
//  StatusTextField.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/20/21.
//

import UIKit

enum StatusType {
    case information
    case error(StatusErrorable)
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
    
    
    let exampleText: String?
    let textFieldPlaceholderText: String?
    let instructionText: String?
    // MARK: - Views -
    lazy var parentStack: UIStackView = .componentStack(elements: [exampleLabel,textField,instructionLabel])
    
    lazy var exampleLabel: UILabel = .captionLabel(text: exampleText)
    lazy var textField: UITextField = .borderedTextField(placeholderText: textFieldPlaceholderText)
    lazy var instructionLabel: UILabel = .captionLabel(text: instructionText)
    
    init(type: StatusType, exampleText: String? = nil, textFieldPlaceholderText: String? = nil, instructionText: String? = nil) {
        
        self.exampleText = exampleText
        self.textFieldPlaceholderText = textFieldPlaceholderText
        self.instructionText = instructionText
        self.type = type
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

class StatusTextField<T: StatusTextFieldDelegate>: UIControl {
    
    weak var statusTextFieldDelegate: T? {
        didSet {
            textFieldView.delegate = statusTextFieldDelegate
        }
    }
    var type: StatusType
    var exampleText: String?
    var textFieldPlaceholderText: String?
    var instructionText: String?
    
    lazy var textFieldView: StatusTextFieldView = StatusTextFieldView(type: type, exampleText: exampleText, textFieldPlaceholderText: textFieldPlaceholderText, instructionText: instructionText)
    
    internal init(type: StatusType, exampleText: String? = nil, textFieldPlaceholderText: String? = nil, instructionText: String? = nil) {
        self.type = type
        self.exampleText = exampleText
        self.textFieldPlaceholderText = textFieldPlaceholderText
        self.instructionText = instructionText
        super.init(frame: .zero)
        textFieldView.delegate = statusTextFieldDelegate
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func setupViews() {
        addSubview(textFieldView)
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            textFieldView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            textFieldView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            textFieldView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    func displayErrorMessage(for error: StatusErrorable) {
        self.textFieldView.displayErrorMessage(for: error)
    }
    
    func displayStatusMessage() {
        self.textFieldView.displayStatusMessage()
    }
    
}
