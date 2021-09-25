//
//  UIView+programmatic.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

extension UIView {
    convenience init(frame: CGRect = .zero, translates constraints: Bool) {
        self.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = constraints
    }
}
