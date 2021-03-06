//
//  UIColor+isDarkColor.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/9/21.
//

import UIKit

extension UIColor {
    
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50
    }
    
    static func contextualColor(for colorToCompareAgainst: UIColor,
                                lightColorToUse: UIColor = .white,
                                darkColorToUse: UIColor = .black) -> UIColor {
        
        colorToCompareAgainst.isDarkColor ? lightColorToUse : darkColorToUse
    }
    
}

extension UIView {
    
    func setContextualBackgroundColor(for color: UIColor) {
        backgroundColor = .contextualColor(for: color)
    }
    
}

extension UILabel {
    func setContextualTextColor(for color: UIColor) {
        textColor = .contextualColor(for: color)
    }
}

extension UIButton {
    func setContextualLinkColor(for colorToCompare: UIColor? = nil, lightColorToUse: UIColor = .white, darkColorToUse: UIColor = .link) {
        var comparativeColor: UIColor
        
        if let existingColor = colorToCompare {
            comparativeColor = existingColor
        } else {
            comparativeColor = backgroundColor ?? .black
        }        
        
        let contextualColor: UIColor = .contextualColor(for: comparativeColor,
                                                        lightColorToUse: lightColorToUse,
                                                        darkColorToUse: darkColorToUse)
        
        setTitleColor(contextualColor, for: .normal)
    }
}
