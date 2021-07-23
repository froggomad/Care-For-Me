//
//  PasswordStatusTextFieldDelegate.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/21/21.
//

import UIKit

final class PasswordStatusTextFieldDelegate: NSObject, StatusTextFieldDelegate {
    
    typealias Error = PasswordError
    
    enum PasswordError: StatusErrorable {
        case tooShort
        case invalidCharacter
        case missingDigit
        case missingLowerAlpha
        case missingUpperAlpha
        case missingSpecial
        
        static let minLength: Int = 6
        static let specialChars: String = "!@#$%^&*"
        static let validCharSet: CharacterSet = ["-","0","1","2","3","4","5","6","7","8","9","!","@","#","$","%","^","&","*"]
        static var displayValidChars: String { "a-z, A-Z, 0-9, \(specialChars)" }
        
        var message: String {
            switch self {
            case .tooShort:
                return "Too Short"
            case .invalidCharacter:
                return "Invalid Character"
            case .missingDigit:
                return "Needs Digit"
            case .missingLowerAlpha:
                return "Needs Lowercase Alphanumeric Character"
            case .missingUpperAlpha:
                return "Needs Uppercase Alphanumeric Character"
            case .missingSpecial:
                return "Needs Special Character"
            }
        }
        
        var instructions: String {
            
            switch self {
            case .tooShort:
                return "Your password must be at least \(Self.minLength) characters"
            case .invalidCharacter:
                return "That's an invalid character. Please use \(Self.displayValidChars)"
            case .missingDigit:
                return "Your password must contain at least 1 digit (0-9)"
            case .missingLowerAlpha:
                return "Your password must contain at least 1 Lowercase Alphanumeric Character (a-z)"
            case .missingUpperAlpha:
                return "Your password must contain at least 1 Uppercase Alphanumeric Character (A-Z)"
            case .missingSpecial:
                return "Your password must include at least 1 special character (\(Self.specialChars))"
            }
        }
    }
    
    var textFields: [StatusTextField<PasswordStatusTextFieldDelegate>]
    
    required init(textFields: [StatusTextField<PasswordStatusTextFieldDelegate>]) {
        self.textFields = textFields
        super.init()
        for textField in self.textFields {
            textField.statusTextFieldDelegate = self
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // TODO: Intercept bad password choices? i.e. stop character from being entered
        
        var text = textField.text ?? ""
        
        guard !string.isEmpty else {
            if string.isBackSpace { // backspace is interpreted as empty String even though it's not
                text.removeLast() // character will be removed, so remove it before comparing
            }
            return isValidPassword(string: text, textField: textField)
        }
        
        return isValidPassword(string: text+string, textField: textField)
    }
    
    @discardableResult func isValidPassword(string: String, textField: UITextField) -> Bool {
        return processChar(string: string, textField: textField)
    }
    
    @discardableResult private func processChar(string: String, textField: UITextField) -> Bool {
        let comparisonSet = CharacterSet.letters.union(Error.validCharSet)
        let lowerInputCharSet = CharacterSet(charactersIn: string.lowercased())
        
        if !comparisonSet.isSuperset(of: lowerInputCharSet) {
            textFieldDictionary[textField]?.displayErrorMessage(for: Error.invalidCharacter)
            TapticEngine.failed.tapUser()
            return false
        } else {
            textFieldDictionary[textField]?.displayStatusMessage()
            return true
        }
    }
    
}
