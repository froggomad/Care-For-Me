//
//  UIStackView+componentView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

extension UIStackView {
    static func componentStack(elements: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: elements)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 2
        
        let horizontalStack = UIStackView(arrangedSubviews: [stack])
        horizontalStack.alignment = .top
        return horizontalStack
    }
}
