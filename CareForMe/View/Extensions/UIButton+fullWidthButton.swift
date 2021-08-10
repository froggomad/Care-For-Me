//
//  UIButton+fullWidthButton.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/12/21.
//

import UIKit

extension UIButton {
    static func fullWidthButton(horizontalPadding: CGFloat = 20, with title: String? = nil, color: UIColor = .named(.link), targetAndSelector: TargetSelector? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let width = UIScreen.main.bounds.width - horizontalPadding - 20
        button.widthAnchor.constraint(equalToConstant: width - horizontalPadding).isActive = true
        
        button.layer.cornerRadius = 10
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setContextualLinkColor(darkColorToUse: .white)
        
        button.layer.shadowColor = UIColor.contextualColor(for: color).cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = .init(width: 1, height: 1)
        button.layer.shadowRadius = 1
        
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        
        guard let targetSelector = targetAndSelector else { return button }
        let target = targetSelector.target
        let selector = targetSelector.selector
        button.addTarget(target, action: selector, for: .touchUpInside)
        
        return button
    }
}
