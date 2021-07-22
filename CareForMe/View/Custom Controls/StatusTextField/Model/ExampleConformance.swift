//
//  File.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/20/21.
//

import UIKit

// MARK: - ViewController used as Controller -
final class ExampleStatusTextFieldPasswordDelegate: UIViewController {
    enum PasswordError: Swift.Error, StatusErrorable {
        case invalidPassword
        
        var message: String {
            switch self {
            case .invalidPassword:
                return "Invalid Password"
            }
        }
        
        var instructions: String {
            switch self {
            case .invalidPassword:
                return "Must contain some stuff you didn't put"
            }
        }
    }
    var textFields: [StatusTextField<ExampleStatusTextFieldPasswordDelegate>]
    typealias Error = PasswordError
    
    var fooController: Foo?
    
    var textField2: StatusTextField<Foo> = StatusTextField<Foo>(type: .information, exampleText: "Example2", textFieldPlaceholderText: "Test2", instructionText: "Instructions 2")
    
    var textField: StatusTextField = StatusTextField<ExampleStatusTextFieldPasswordDelegate>(type: .information, exampleText: "Example", textFieldPlaceholderText: "Test", instructionText: "Instructions")
    
    lazy var stack: UIStackView = .componentStack(elements: [textField, textField2])
    
    required init(textFields: [StatusTextField<ExampleStatusTextFieldPasswordDelegate>]) {
        self.textFields = [textField]
        super.init(nibName: nil, bundle: nil)
        for textField in self.textFields {
            textField.statusTextFieldDelegate = self
        }
        fooController = .init(textFields: [textField2])
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    override func loadView() {
        view = stack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField2.statusTextFieldDelegate = fooController
        textField.statusTextFieldDelegate = self
        view.backgroundColor = .systemBackground
    }
    
}

extension ExampleStatusTextFieldPasswordDelegate: StatusTextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text == "Foo" {
            print("entered super secret testing mode, try an \"!\"")
            if string == "!" {
                textFieldDictionary[textField]?.displayErrorMessage(for: Error.invalidPassword)
            }
        } else if textField.text == "Foo!" {
            textFieldDictionary[textField]?.displayStatusMessage()
        }
        return true
        
    }
    
}

// MARK: - Outside Controller -
final class Foo: NSObject, StatusTextFieldDelegate {
    
    
    
    enum FooError: Swift.Error, StatusErrorable {
        case badStuffHappenedHere
        
        var message: String { "Empty" }
        var instructions: String { "This field cannot be empty" }
    }
    
    lazy var textFields: [StatusTextField<Foo>] = statusTextField != nil ? [statusTextField!] : []
    
    init(textFields: [StatusTextField<Foo>]) {
        super.init()
        self.textFields = textFields
        for textField in textFields {
            textField.statusTextFieldDelegate = self
        }
    }
    
    weak var statusTextField: StatusTextField<Foo>?
    
    typealias Error = FooError
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let allEmpty = text.isEmpty && string.isEmpty
        let stringIsBackSpace = text.isEmpty && string == .backSpace
        let willBecomeEmpty = (text.count == 1 && string == .backSpace) || (text.count == 1 && string.isEmpty)
        
        if allEmpty || stringIsBackSpace || willBecomeEmpty {
            textFieldDictionary[textField]?.displayErrorMessage(for: Error.badStuffHappenedHere)
        } else {
            textFieldDictionary[textField]?.displayStatusMessage()
        }
        return true
    }
    
}

extension String {
    static let backSpace = String(UnicodeScalar(8))
}
