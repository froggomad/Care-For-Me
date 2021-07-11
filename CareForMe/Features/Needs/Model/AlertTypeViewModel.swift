//
//  AlertViewModel.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

class AlertTypeViewModel {
    var title: String
    var message: String
    var image: UIImage
    
    init(title: String, message: String, image: UIImage) {
        self.title = title
        self.message = message
        self.image = image
    }
}
