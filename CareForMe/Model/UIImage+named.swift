//
//  UIImage+named.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/16/21.
//

import UIKit

extension UIImage {
    enum NamedImage: String {
        case food
        case drink
        case medication
        case chat
        case important
        case spendTime
    }
    
    static func named(_ image: NamedImage) -> UIImage {
        UIImage(named: image.rawValue)!
    }
}
