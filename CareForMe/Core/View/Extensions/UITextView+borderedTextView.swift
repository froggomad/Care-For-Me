//
//  UITextView+borderedTextView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/26/21.
//

import UIKit

extension UITextView {
    static func borderedTextView() -> UITextView {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.named(.secondaryLink).cgColor
        textView.layer.borderWidth = 1
        return textView
    }
}
