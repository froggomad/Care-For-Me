//
//  UIButton+underlinedTitle.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

extension UIButton {
    func underlinedTitle(with text: String?) {
        guard let text = text else { return }
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: text, attributes: underlineAttribute)
        setAttributedTitle(underlineAttributedString, for: .normal)
    }
}
