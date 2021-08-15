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
    private var textFieldType: TextFieldType
    private var exampleText: String?
    private var textFieldPlaceholderText: String?
    private var instructionText: String?
    
    var text: String? {
        get { textFieldView.textField.text }
        set { textFieldView.textField.text = newValue }
    }
    
    var error: StatusErrorable? {
        switch self.type {
        case .information:
            return nil
        case let .error(error):
            return error
        }
    }
    
    lazy var textFieldView: StatusTextFieldView = StatusTextFieldView(textFieldType: textFieldType, type: type, exampleText: exampleText, textFieldPlaceholderText: textFieldPlaceholderText, instructionText: instructionText)
    
    required init(textFieldType: TextFieldType, type: StatusType, exampleText: String? = nil, textFieldPlaceholderText: String? = nil, instructionText: String? = nil) {
        self.textFieldType = textFieldType
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
    
    /// handles when backspace is tapped in textField
    /// - no text selected
    ///   - removes a character from 1 position behind the
    ///   cursor and returns the result
    /// - text selected
    ///   - removes all of selected string, leaving
    ///   remaining string intact and returns the result
    func backSpace() -> String {
        let textField = textFieldView.textField
        guard var text = text,
              let selectedRange = textField.selectedTextRange,
              !text.isEmpty
        else { return "" }
        
        let offset = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
        
        if selectedRange.isEmpty {
            let index = text.index(text.startIndex, offsetBy: offset-1)
            text.remove(at: index)
        } else {
            let beginningIndex = text.index(text.startIndex, offsetBy: offset)
            
            let endingOffset = textField.offset(from: selectedRange.start, to: selectedRange.end)
            let endingIndex = text.index(beginningIndex, offsetBy: endingOffset - 1)
            
            text.removeSubrange(beginningIndex...endingIndex)
        }
        
        return text
    }
    
}
