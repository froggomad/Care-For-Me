//
//  UITextField+borderedTextField.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

extension UITextField {
    static func borderedTextField(padding: CGFloat = 10, borderColor: UIColor = .label, borderWidth: CGFloat = 1,  placeholderText: String? = nil, text: String? = nil) -> UITextField {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = padding
        
        let leftPaddingView = UIView(frame: .init(x: 0, y: 0, width: padding, height: textField.frame.height))
        let rightPaddingView = UIView(frame: .init(x: 0, y: 0, width: padding, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.rightView = rightPaddingView
        textField.placeholder = placeholderText
        textField.text = text
        
        textField.layer.borderColor = borderColor.cgColor
        textField.layer.borderWidth = borderWidth
        return textField
    }
}
