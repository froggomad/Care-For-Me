//
//  NeedsModel.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/10/21.
//

import UIKit

struct NeedsCategory: Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var needs: [Need] = []
    var color: CodableColor = .init(uiColor: .systemBackground)
    
    @discardableResult mutating func addNeed(_ need: Need) -> Bool {
        guard !needs.contains(need) else { return false }
        needs.append(need)
        return true
    }
    
    static func ==(lhs: NeedsCategory, rhs: NeedsCategory) -> Bool {
        lhs.id == rhs.id
    }
}

struct Need: Codable, Equatable {
    var needPhotoModel: NamedPhoto
    lazy var title: String = needPhotoModel.title
}

struct CodableColor : Codable {
    var hue : CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0

    var uiColor : UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    init(uiColor : UIColor) {
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    }
}
