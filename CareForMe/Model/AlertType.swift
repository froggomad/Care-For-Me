//
//  AlertType.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

protocol AlertCategorizable: AnyObject, Codable {
    var id: UUID { get }
    var color: String { get set }
    var type: String { get set }
    var alerts: [CareAlertType] { get set }
}

class AlertCategory: AlertCategorizable, CustomStringConvertible, Codable {
    
    var id: UUID
    var color: String
    var type: String
    var alerts: [CareAlertType] = []
    
    init(id: UUID, color: String, type: String) {
        self.id = id
        self.color = color
        self.type = type
    }
    
    /// debug description
    var description: String {
            """
            type: \(type)
            color: \(color)
            alerts: \(alerts)
            """
    }
    
}

struct CareAlertType: CustomStringConvertible, Codable {
    
    var id: UUID
    unowned var category: AlertCategory
    var stockPhotoName: NamedPhoto
    var title: String
    var message: String
    
    var viewModel: AlertTypeViewModel {
        return AlertTypeViewModel(
            title: title,
            message: message,
            image: .stockImage(from: stockPhotoName).withTintColor(.label)
        )
    }
    /// debug description
    var description: String {
            """
            category: \(category)
            title: \(title)
            message: \(message)
            image: \(stockPhotoName.image )
            """
    }
    
    internal init(id: UUID, category: AlertCategory, stockPhotoName: NamedPhoto, title: String? = nil, message: String) {
        self.id = id
        self.category = category
        self.stockPhotoName = stockPhotoName
        self.title = title ?? stockPhotoName.title
        self.message = message
    }
    
}
