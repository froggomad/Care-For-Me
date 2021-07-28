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
    var alerts: [CareTypeable] { get set }
}

class AlertCategory: AlertCategorizable, CustomStringConvertible, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case color
        case title
        case alerts
    }
    
    var id: UUID
    var color: CodableColor
    var title: String
    var alerts: [CareTypeable]
    
    required init(from decoder: Decoder) throws {
        let decoder = try decoder.container(keyedBy: CodingKeys.self)
        let id = try decoder.decode(String.self, forKey: .id)
        let uuid = UUID(uuidString: id) ?? UUID()
        self.id = uuid
        
        color = try decoder.decode(CodableColor.self, forKey: .color)
        
        title = try decoder.decode(String.self, forKey: .title)
        
        alerts = try decoder.decode([CareAlertType].self, forKey: .alerts)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(color, forKey: .color)
        try container.encode(title, forKey: .title)
        try container.encode(alerts as? [CareAlertType], forKey: .alerts)
    }
    
    init(id: UUID, color: CodableColor, type: String, alerts: [CareAlertType] = []) {
        self.id = id
        self.color = color
        self.title = type
        self.alerts = alerts
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

struct CareAlertType: CustomStringConvertible, Codable, CareTypeable {
    
    var id: UUID
    unowned var category: AlertCategorizable
    var stockPhotoName: NamedPhoto
    var title: String
    var message: String
    
    var viewModel: AlertTypeViewModel {
        return AlertTypeViewModel(
            title: title,
            message: message,
            data: UIImage.stockImage(from: stockPhotoName).jpegData(compressionQuality: 60) ?? Data()
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case category
        case stockPhotoName
        case title
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: id) ?? UUID()
        
        category = try container.decode(NeedsCategory.self, forKey: .category)
        
        stockPhotoName = try container.decode(NamedPhoto.self, forKey: .stockPhotoName)
        
        title = try container.decode(String.self, forKey: .title)
        
        message = try container.decode(String.self, forKey: .message)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id.uuidString, forKey: .id)
        
        try container.encode(category as? NeedsCategory, forKey: .category)
        
        try container.encode(stockPhotoName, forKey: .stockPhotoName)
        
        try container.encode(title, forKey: .title)
        
        try container.encode(message, forKey: .message)
    }
    
}
