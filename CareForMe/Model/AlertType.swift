//
//  AlertType.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

protocol AlertCategorizable: AnyObject {
    var id: UUID { get }
    var color: UIColor { get set }
    var type: String { get set }
    var alerts: [CareAlert] { get set }
}

class AlertCategory: AlertCategorizable {
    
    var id: UUID
    var color: UIColor
    var type: String
    var alerts: [CareAlert] = []
    
    init(id: UUID, color: UIColor, type: String) {
        self.id = id
        self.color = color
        self.type = type
    }
    
}

struct CareAlert {
    var id: UUID
    unowned var category: AlertCategorizable
    var title: String
    var message: String
    var date: Date
    var image: UIImage
    
    var viewModel: AlertViewModel {
        return AlertViewModel(
            title: title,
            message: message,
            image: image,
            date: date
        )
    }
    /// debug description
    var description: String {
            """
            category: \(category)
            title: \(title)
            message: \(message)
            date: \(date)
            image: \(image)
            """
    }
}
