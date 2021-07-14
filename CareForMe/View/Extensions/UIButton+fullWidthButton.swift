//
//  UIButton+fullWidthButton.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/12/21.
//

import UIKit

typealias TargetSelector = (target: Any, selector: Selector)

extension UIButton {
    static func fullWidthButton(with title: String? = nil, color: UIColor = .named(.link), targetAndSelector: TargetSelector? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 10
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        
        guard let (target, selector) = targetAndSelector else { return button }
        
        button.addTarget(target, action: selector, for: .touchUpInside)
        return button
    }
}
