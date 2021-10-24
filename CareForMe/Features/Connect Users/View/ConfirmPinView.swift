//
//  ConfirmPinView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/8/21.
//

import UIKit

class ConfirmPINViewController: UIViewController {
    lazy var confirmPINView: InstructionView = InstructionView(title: "Confirm PIN", instructions: "Enter the PIN your companion provided and tap Confirm", imageFilename: nil, buttonTitle: "Confirm", selectionDelegate: TargetSelector(target: self, selector: #selector(confirmCode)))
    
    let pinLength: Int = 6
    
    lazy var pinCodeTextfieldDelegate = PinCodeStatusTextFieldDelegate(textFields: [statusTextField], pinLength: pinLength)
    
    lazy var statusTextField: StatusTextField<PinCodeStatusTextFieldDelegate> = {
        let textField: StatusTextField = StatusTextField<PinCodeStatusTextFieldDelegate>(textFieldType: .email, type: .information, exampleText: "Please enter link code:", instructionText: "Please enter the \(pinLength) digit code your companion provided")
        return textField
    }()
    
    override func loadView() {
        view = confirmPINView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusTextField.statusTextFieldDelegate = pinCodeTextfieldDelegate
        statusTextField.textFieldView.textField.placeholder = "Enter \(pinCodeTextfieldDelegate.pinLength) Digit Code"
        confirmPINView.addView(statusTextField)
    }
    
    @objc func confirmCode() {
        guard let user = AuthService.shared.user else {
            let vc = AuthViewController(authType: .login)
            present(vc, animated: true)
            return
        }
        UserLinkController.joinRequest(userId: user.privateDetails.userId, joinCode: pinCodeTextfieldDelegate.text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let status):
                DispatchQueue.main.async {
                    if status {
                        self.presentAlert(title: "Join Request Sent", message: "You've successfully requested to link your account!") { _ in
                            self.dismiss(animated: true)
                        }
                    } else {
                        self.presentAlert(title: "Invalid Join Code", message: "Code not found or code is expired. Please verify the code or ask the other user to generate a new join code in their settings.")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

final class PinCodeStatusTextFieldDelegate: NSObject, StatusTextFieldDelegate {
    var pinLength: Int
    var textFields: [StatusTextField<PinCodeStatusTextFieldDelegate>]
    var text: String {
        textFields[0].text ?? ""
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string != "" else { // handles backspace char
            textFieldDictionary[textField]?.displayStatusMessage()
            return true
        }
        
        if let num = Int(string) {
            guard let text = textField.text,
                  text.count <= pinLength - 1 else { // 5 plus the replacement string
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
                return "Code too Short"
            case .tooLong:
                return "Code too Long"
            case .invalidChar:
                return "Invalid Character"
            }
        }
        
        var instructions: String {
            switch self {
            case let .tooShort(pinLength), let .tooLong(pinLength):
                return "Please enter \(pinLength) digits, matching the code your companion provided to you and tap confirm"
            case .invalidChar:
                return "Please enter a digit 0-9"
            }
        }
    }
    
    
    
}
