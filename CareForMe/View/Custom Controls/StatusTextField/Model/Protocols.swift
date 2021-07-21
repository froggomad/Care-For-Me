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
    associatedtype Error: StatusErrorable
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}
