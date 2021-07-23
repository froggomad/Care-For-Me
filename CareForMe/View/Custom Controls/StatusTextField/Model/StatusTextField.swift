//
//  StatusTextField.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/21/21.
//

import UIKit

class StatusTextField<T: StatusTextFieldDelegate>: UIControl {
    
    weak var statusTextFieldDelegate: T? {
        didSet {
            textFieldView.delegate = statusTextFieldDelegate
        }
    }
    private var type: StatusType
    private var exampleText: String?
    private var textFieldPlaceholderText: String?
    private var instructionText: String?
    
    var text: String? {
        textFieldView.textField.text
    }
    
    var error: StatusErrorable? {
        switch self.type {
        case .information:
            return nil
        case let .error(error):
            return error
        }
    }
    
    lazy var textFieldView: StatusTextFieldView = StatusTextFieldView(type: type, exampleText: exampleText, textFieldPlaceholderText: textFieldPlaceholderText, instructionText: instructionText)
    
    required init(type: StatusType, exampleText: String? = nil, textFieldPlaceholderText: String? = nil, instructionText: String? = nil) {
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
    
    /// removes a character from 1 position behind the cursor and returns the result
    func backSpace() -> String {
        let textField = textFieldView.textField
        guard var text = text,
              let selectedRange = textField.selectedTextRange,
              !text.isEmpty
        else { return "" }
        
        let offset = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
        
        let index = text.index(text.startIndex, offsetBy: offset-1)
        text.remove(at: index)
        return text
    }
    
}
