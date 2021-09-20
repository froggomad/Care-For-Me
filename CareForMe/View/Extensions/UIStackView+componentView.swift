//
//  UIStackView+componentView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

extension UIStackView {
    static func componentStack(elements: [UIView], distribution: UIStackView.Distribution = .fillProportionally, verticalAlignment: UIStackView.Alignment = .fill, horizontalAlignment: UIStackView.Alignment = .top, spacing: CGFloat = 2, horizontalDistribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: elements)
        stack.axis = .vertical
        stack.distribution = distribution
        stack.alignment = verticalAlignment
        stack.spacing = spacing
        
        let horizontalStack = UIStackView(arrangedSubviews: [stack])
        horizontalStack.alignment = horizontalAlignment
        horizontalStack.distribution = horizontalDistribution
        return horizontalStack
    }
}
