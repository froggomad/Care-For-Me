//
//  Protocols.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/20/21.
//

import UIKit

protocol StatusErrorable: Error {
    var message: String { get }
    var instructions: String { get }
}

/// Associated Type is used to guarantee class has access to required Error type (`StatusErrorable`)
protocol StatusTextFieldDelegate: UITextFieldDelegate {
    var textFields: [StatusTextField<Self>] { get set }
    var textFieldDictionary: [UITextField: StatusTextField<Self>] { get }
    associatedtype Error: StatusErrorable
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    init(textFields: [StatusTextField<Self>])
}

extension StatusTextFieldDelegate {
    var textFieldDictionary: [UITextField: StatusTextField<Self>] {
        Dictionary(uniqueKeysWithValues: self.textFields.map { ($0.textFieldView.textField, $0) })
    }
}
