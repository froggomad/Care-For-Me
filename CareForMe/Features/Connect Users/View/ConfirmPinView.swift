//
//  ConfirmPinView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/8/21.
//

import UIKit

class ConfirmPINViewController: UIViewController {
    lazy var myView: InstructionView = InstructionView(title: "Confirm PIN", instructions: "Enter the PIN your companion provided and tap the button", imageFilename: nil, buttonTitle: "Tap Me", selectionDelegate: TargetSelector(target: self, selector: #selector(foo)))
    
    let pinLength: Int = 6
    
    lazy var pinCodeTextfieldDelegate = PinCodeStatusTextFieldDelegate(textFields: [statusTextField], pinLength: pinLength)
    
    lazy var statusTextField: StatusTextField<PinCodeStatusTextFieldDelegate> = {
        let textField: StatusTextField = StatusTextField<PinCodeStatusTextFieldDelegate>(textFieldType: .email, type: .information, exampleText: "Please enter link code:", instructionText: "Please enter the \(pinLength) digit code your companion provided")
        return textField
    }()
    
    override func loadView() {
        view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusTextField.statusTextFieldDelegate = pinCodeTextfieldDelegate
        statusTextField.textFieldView.textField.placeholder = "Enter \(pinCodeTextfieldDelegate.pinLength) Digit Code"
        myView.addView(statusTextField)
    }
    
    @objc func foo() {
        print("foo")
    }
}

final class PinCodeStatusTextFieldDelegate: NSObject, StatusTextFieldDelegate {
    var pinLength: Int
    var textFields: [StatusTextField<PinCodeStatusTextFieldDelegate>]
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string != "" else { // handles backspace char
            textFieldDictionary[textField]?.displayStatusMessage()
            return true
        }
        
        if let num = Int(string) {
            guard let text = textField.text,
                  text.count <= 5 else { // 5 plus the replacement string
                textFieldDictionary[textField]?.displayErrorMessage(for: Error.tooLong(pinLength: pinLength))
                return false
            }
            
            textFieldDictionary[textField]?.displayStatusMessage()
            return num <= 9 && num >= 0
        } else {
            textFieldDictionary[textField]?.displayErrorMessage(for: Error.invalidChar)
            return false
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    init(textFields: [StatusTextField<PinCodeStatusTextFieldDelegate>]) {
        self.textFields = textFields
        self.pinLength = Pin.length
        super.init()
    }
    
    init(textFields: [StatusTextField<PinCodeStatusTextFieldDelegate>], pinLength: Int = Pin.length) {
        self.textFields = textFields
        self.pinLength = pinLength
        super.init()
    }
    
    typealias Error = PinError
    
    enum PinError: StatusErrorable {
        
        case tooShort(pinLength: Int)
        case invalidChar
        case tooLong(pinLength: Int)
        
        var message: String {
            switch self {
            case .tooShort:
                return "Too Short"
            case .tooLong:
                return "Too Long"
            case .invalidChar:
                return "Invalid Character"
            }
        }
        
        var instructions: String {
            switch self {
            case let .tooShort(pinLength), let .tooLong(pinLength):
                return "Please enter \(pinLength) digits, matching the code your companion provided to you"
            case .invalidChar:
                return "Please enter a digit 0-9"
            }
        }
    }
    
    
    
}
