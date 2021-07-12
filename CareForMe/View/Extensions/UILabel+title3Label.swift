//
//  UILabel+title3Label.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

extension UILabel {
    static func title3Label(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = .preferredFont(for: .title3, weight: .bold)
        return label
    }
}
