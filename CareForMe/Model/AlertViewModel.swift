//
//  AlertViewModel.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

class AlertViewModel {
    var title: String
    var message: String
    var image: UIImage
    var date: Date
    
    init(title: String, message: String, image: UIImage, date: Date) {
        self.title = title
        self.message = message
        self.image = image
        self.date = date
    }
}
