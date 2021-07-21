//
//  File.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/20/21.
//

import UIKit

enum PasswordError: StatusErrorable {
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
// MARK: - ViewController used as Controller -
final class ExampleStatusTextFieldPasswordDelegate: UIViewController, UITextFieldDelegate {
    typealias Error = PasswordError
    
    let fooController = Foo()
    
    var textField2: StatusTextField<Foo> = StatusTextField<Foo>(type: .information, exampleText: "Example2", textFieldPlaceholderText: "Test2", instructionText: "Instructions 2")
    
    var textField: StatusTextField = StatusTextField<ExampleStatusTextFieldPasswordDelegate>(type: .information, exampleText: "Example", textFieldPlaceholderText: "Test", instructionText: "Instructions")
    
    lazy var stack: UIStackView = .componentStack(elements: [textField, textField2])
    
    override func loadView() {
        view = stack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField2.statusTextFieldDelegate = fooController
        textField.statusTextFieldDelegate = self
        view.backgroundColor = .systemBackground
    }
    
    
    func displayMessage(type: StatusType) {
        switch type {
        case let .error(error):
            textField.displayErrorMessage(for: error)
        case .information:
            textField.displayStatusMessage()
        }
    }
    
}

extension ExampleStatusTextFieldPasswordDelegate: StatusTextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text == "Foo" {
            print("entered super secret testing mode, try an \"!\"")
            if string == "!" {
                displayMessage(type: .error(Error.invalidPassword))
            }
        } else if textField.text == "Foo!" {
            displayMessage(type: .information)
        }
        return true
        
    }
    
}

// MARK: - Outside Controller -
enum FooError: StatusErrorable {
    var message: String { "bad" }
    
    var instructions: String { "bad juju, abort now" }
    
    case badStuffHappenedHere
    
}

class Foo: NSObject, StatusTextFieldDelegate, UITextFieldDelegate {
    typealias Error = FooError
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Foo")
        return true
    }
    
}
