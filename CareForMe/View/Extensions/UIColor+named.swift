//
//  UIColor+named.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/16/21.
//

import UIKit


extension UIColor {
    enum NamedColor: String {
        case red
        case yellow
    }
    static func named(_ color: NamedColor) -> UIColor {
        return UIColor(named: color.rawValue)!
    }
}

