//
//  UILabel+preferredFont(for style, weight).swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/2/21.
//

import UIKit

extension UIFont {
    static func preferredFont(for style: TextStyle, weight: Weight = .regular) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}
