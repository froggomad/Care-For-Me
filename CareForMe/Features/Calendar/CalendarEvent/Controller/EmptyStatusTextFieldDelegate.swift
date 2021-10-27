//
//  EmptyStatusTextFieldDelegate.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/26/21.
//

import UIKit

final class EmptyStatusTextFieldDelegate: NSObject, StatusTextFieldDelegate {
    var textFields: [StatusTextField<EmptyStatusTextFieldDelegate>]
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let statusTextField = textFieldDictionary[textField] else { return true }
        if !string.isEmpty {
            statusTextField.displayStatusMessage()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let statusTextField = textFieldDictionary[textField] else { return true }

        if textField.text?.isEmpty ?? true {
            statusTextField.displayErrorMessage(for: EmptyStatusError.empty)
        } else {
            statusTextField.displayStatusMessage()
        }
        
        return true
    }
    
    required init(textFields: [StatusTextField<EmptyStatusTextFieldDelegate>]) {
        self.textFields = textFields
    }
    
    enum EmptyStatusError: Swift.Error, StatusErrorable {
        case empty

        var message: String { "This field can't be left blank" }
        
        var instructions: String { "Please enter something in this field" }
        
    }
    typealias Error = EmptyStatusError
    
    
}
