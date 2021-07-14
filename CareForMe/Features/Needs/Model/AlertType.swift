//
//  AlertType.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

protocol AlertCategorizable: AnyObject, Codable {
    var id: UUID { get }
    var color: CodableColor { get set }
    var title: String { get set }
    var alerts: [CareAlertType] { get set }
}

class AlertCategory: AlertCategorizable, CustomStringConvertible, Codable {
    
    var id: UUID
    var color: CodableColor
    var title: String
    var alerts: [CareAlertType] = []
    
    init(id: UUID, color: CodableColor, type: String) {
        self.id = id
        self.color = color
        self.title = type
    }
    
    /// debug description
    var description: String {
            """
            type: \(title)
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
            image: .stockImage(from: stockPhotoName)
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
    
    init(id: UUID, category: AlertCategory, stockPhotoName: NamedPhoto, title: String? = nil, message: String) {
        self.id = id
        self.category = category
        self.stockPhotoName = stockPhotoName
        self.title = title ?? stockPhotoName.title
        self.message = message
    }
    
}
