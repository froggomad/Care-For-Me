//
//  AlertViewModel.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

class AlertTypeViewModel: Codable {
    var title: String
    var message: String
    var data: Data
    var image: UIImage {
        .init(data: data) ?? UIImage()
    }
    
    init(title: String, message: String, data: Data) {
        self.title = title
        self.message = message
        self.data = data
    }
}
