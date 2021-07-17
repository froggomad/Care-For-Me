//
//  UIColor+named.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/16/21.
//

import UIKit


extension UIColor {
    enum NamedColor: String {
        case link
        case highlight
        case secondaryLink
    }
    static func named(_ color: NamedColor) -> UIColor {
        return UIColor(named: color.rawValue)!
    }
}

