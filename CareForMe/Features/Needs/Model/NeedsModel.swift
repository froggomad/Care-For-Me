//
//  NeedsModel.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/10/21.
//

import UIKit

class NeedsCategory: Codable, Equatable, AlertCategorizable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case alerts
        case color
    }
    
    var id: UUID = UUID()
    var title: String
    var alerts: [CareTypeable] = []
    var color: CodableColor
    
    var needs: [Need] {
        alerts as! [Need]
    }
    
    @discardableResult func addNeed(_ need: Need) -> Bool {
        guard !needs.contains(need) else { return false }
        alerts.append(need)
        return true
    }
    
    static func ==(lhs: NeedsCategory, rhs: NeedsCategory) -> Bool {
        lhs.id == rhs.id || lhs.title == rhs.title
    }
    
    init(id: UUID = UUID(), title: String, alerts: [CareTypeable] = [], color: CodableColor) {
        self.id = id
        self.title = title
        self.alerts = alerts
        self.color = color
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let uuid = UUID(uuidString: id) ?? UUID()
        self.id = uuid
        
        title = try container.decode(String.self, forKey: .title)
        
        color = try container.decode(CodableColor.self, forKey: .color)
        
        alerts = try container.decode([Need].self, forKey: .alerts)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(color, forKey: .color)
        try container.encode(needs, forKey: .alerts)
    }
}

struct Need: Codable, Equatable, CareTypeable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case category
        case stockPhotoName
        case title
        case message
    }
    
    static func == (lhs: Need, rhs: Need) -> Bool {
        lhs.id == rhs.id
    }
    
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
    
    init(id: UUID, category: AlertCategorizable, stockPhotoName: NamedPhoto, title: String, message: String) {
        self.id = id
        self.category = category
        self.stockPhotoName = stockPhotoName
        self.title = title
        self.message = message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let uuid = UUID(uuidString: id) ?? UUID()
        self.id = uuid
        
        category = try container.decode(AlertCategory.self, forKey: .stockPhotoName)
        
        stockPhotoName = try container.decode(NamedPhoto.self, forKey: .stockPhotoName)
        
        title = try container.decode(String.self, forKey: .title)
        
        message = try container.decode(String.self, forKey: .message)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(category as? NeedsCategory, forKey: .category)
        try container.encode(stockPhotoName, forKey: .stockPhotoName)
        try container.encode(title, forKey: .title)
        try container.encode(message, forKey: .message)
    }
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
