//
//  CareTypeable.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/28/21.
//

import Foundation

protocol CareTypeable: Codable {
    var id: UUID { get }
    var category: AlertCategorizable { get set }
    var stockPhotoName: NamedPhoto { get set }
    var title: String { get set }
    var message: String { get set }
    var viewModel: AlertTypeViewModel { get }
}
