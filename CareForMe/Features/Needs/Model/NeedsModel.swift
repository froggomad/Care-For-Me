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
