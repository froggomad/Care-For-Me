//
//  NeedsModel.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/10/21.
//

import UIKit

struct NeedsCategory: Codable {
    var title: String
    var needs: [Need] = []
}

struct Need: Codable {
    var needPhotoModel: NamedPhoto
    lazy var title: String = needPhotoModel.title
}
