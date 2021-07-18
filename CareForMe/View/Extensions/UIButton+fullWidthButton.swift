//
//  UIButton+fullWidthButton.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/12/21.
//

import UIKit

class TargetSelector {
    var target: Any?
    var selector: Selector
    
    init(target: Any?, selector: Selector) {
        self.target = target
        self.selector = selector
    }    
}

extension UIButton {
    static func fullWidthButton(with title: String? = nil, color: UIColor = .named(.link), targetAndSelector: TargetSelector? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 10
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        
        guard let targetSelector = targetAndSelector else { return button }
        let target = targetSelector.target
        let selector = targetSelector.selector
        button.addTarget(target, action: selector, for: .touchUpInside)
        
        return button
    }
}
