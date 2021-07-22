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
        
        static var specialChars: String { "!@#$%^&*" }
        static var validChars: String { "a-z, A-Z, 0-9, \(specialChars)" }
        
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
                return "Your password must be at least 6 characters"
            case .invalidCharacter:
                return "Your password contains unknown characters. Please use \(Self.validChars)"
            case .missingDigit:
                return "Your password must contain at least 1 digit (0-9)"
            case .missingLowerAlpha:
                return "Your password must contain at least 1 Lowercase Alphanumeric Character (a-z)"
            case .missingUpperAlpha:
                return "Your password must contain at least 1 Uppercase Alphanumeric Character (A-Z)"
            case .missingSpecial:
                return "Your password must include at least 1 special character (\(Self.specialChars)"
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
        
        let customSet: CharacterSet = [" ", "-", "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","!","@","#","$","%","^","&","*"]
        let comparisonSet = CharacterSet.letters.union(customSet)         
        
        if !comparisonSet.isSuperset(of: CharacterSet(charactersIn: string)) {
            textFieldDictionary[textField]?.displayErrorMessage(for: Error.invalidCharacter)
        } else {
            textFieldDictionary[textField]?.displayStatusMessage()
        }
        return true
    }
    
}
