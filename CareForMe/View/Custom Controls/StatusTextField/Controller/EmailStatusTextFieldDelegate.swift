//
//  EmailStatusTextFieldDelegate.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/22/21.
//

import UIKit

final class EmailStatusTextFieldDelegate: NSObject, StatusTextFieldDelegate {
    
    typealias Error = PasswordError
    
    enum PasswordError: StatusErrorable {
        case invalidCharacter
        case missingDot
        case missingMonkeyTail
        case dotAsFirst
        case dotAsLast
        //fallback for cases such as .. not surrounded by \"\"
        case regexValidationString
        
//        static let quotedChars: String = "\"(),:;<>@[\\]"
        static let specialChars: String = "!#$%&'*+-/=?^_`{|}~"
        static let validCharSet: CharacterSet = ["-","0","1","2","3","4","5","6","7","8","9","!","@","#","$","%","^","&","*",".","\""]
        static var displayValidChars: String { "a-z, A-Z, 0-9, \(specialChars)" }
        static let monkeyTailChar = "@"
        static let validRegexString = "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\\\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        var message: String {
            switch self {
            case .invalidCharacter:
                return "Invalid Character"
            case .missingDot:
                return "Missing Domain"
            case .missingMonkeyTail:
                return "Missing @"
            case .dotAsFirst:
                return "\".\" first"
            case .dotAsLast:
                return "\".\" last"
            case .regexValidationString:
                return "Unknown Error"
            }
        }
        
        var instructions: String {
            
            switch self {
            case .invalidCharacter:
                return "That's an invalid character. Please use \(Self.displayValidChars)"
            case .missingDot:
                return "You seem to be missing the domain name and/or extension (ex: gmail.com)"
            case .missingMonkeyTail:
                return "You seem to be missing the \"commercial at\" (\"\(Self.monkeyTailChar)\") sign"
            case .dotAsFirst:
                return "A dot may not be the first character in an email address"
            case .dotAsLast:
                return "A dot may not be the last character in an email address"
            case .regexValidationString:
                return "An unknown issue occured when validating your email address. Please ensure it is formatted as: user@domain.com"
            }
        }
    }
    
    var textFields: [StatusTextField<EmailStatusTextFieldDelegate>]
    
    required init(textFields: [StatusTextField<EmailStatusTextFieldDelegate>]) {
        self.textFields = textFields
        super.init()
        for textField in self.textFields {
            textField.statusTextFieldDelegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(false)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        defer { textField.resignFirstResponder() }
        
        guard let text = textField.text,
              let statusTextField = textFieldDictionary[textField] else { return }
        
        guard text.last != "." else {
            statusTextField.displayErrorMessage(for: Error.dotAsLast)
            TapticEngine.failed.tapUser()
            return
        }
        
        guard text.contains("@") else {
            statusTextField.displayErrorMessage(for: Error.missingMonkeyTail)
            TapticEngine.failed.tapUser()
            return
        }
        
        guard text.contains(".") else {
            statusTextField.displayErrorMessage(for: Error.missingDot)
            TapticEngine.failed.tapUser()
            return
        }
        
        let range = NSRange(location: 0, length: text.utf16.count)
        
        guard let regex = try? NSRegularExpression(pattern: Error.validRegexString),
              regex.firstMatch(in: text, options: [], range: range) != nil else {
            statusTextField.displayErrorMessage(for: Error.regexValidationString)
            TapticEngine.failed.tapUser()
            return
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var text = textField.text ?? ""
        
        
        guard !string.isEmpty else {
            guard let statusTextField = textFieldDictionary[textField] else { return true }
            if string.isBackSpace { // backspace is interpreted as empty String even though it's not
                text = statusTextField.backSpace() // character will be removed, so remove it before comparing
            }
            return isValidEmail(string: text, textField: textField)
        }
        
        return isValidEmail(string: text+string, textField: textField)
    }
    
    @discardableResult func isValidEmail(string: String, textField: UITextField) -> Bool {
        return processChar(string: string, textField: textField)
    }
    // .dotAsLast will need to be validated on return
    @discardableResult private func processChar(string: String, textField: UITextField) -> Bool {
        guard let statusTextField = textFieldDictionary[textField] else { return false }
        
        guard string.first != "." else {
            statusTextField.displayErrorMessage(for: Error.dotAsFirst)
            TapticEngine.failed.tapUser()
            return false
        }
        
        let comparisonSet = CharacterSet.letters.union(Error.validCharSet)
        let lowerInputCharSet = CharacterSet(charactersIn: string.lowercased())
        
        if !comparisonSet.isSuperset(of: lowerInputCharSet) {
            statusTextField.displayErrorMessage(for: Error.invalidCharacter)
            TapticEngine.failed.tapUser()
            return false
        } else {
            statusTextField.displayStatusMessage()
            return true
        }
    }
    
}
