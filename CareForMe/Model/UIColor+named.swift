//
//  UIColor+named.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/16/21.
//

import UIKit

enum NamedColor: String {
    case care
    case companionship
}
extension UIColor {
    static func named(_ color: NamedColor) -> UIColor {
        return UIColor(named: color.rawValue)!
    }
}

