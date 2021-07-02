//
//  AlertType.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

enum AlertChoice: String, CustomStringConvertible {
    case care
    case companionship
    
    var description: String {
        return String(describing: rawValue).capitalized
    }
    
    var count: Int {
        switch self {
        case .care:
            return CareType.allCases.count
        case .companionship:
            return CompanionType.allCases.count
        }
    }
    
    var color: UIColor {
        switch self {
        case .care:
            return UIColor.named(.care)
        case .companionship:
            return UIColor.named(.companionship)
        }
    }
    
}

enum CareType: String, CaseIterable, CustomStringConvertible, NeedType {
    case drink
    case food
    case medication
    
    var description: String {
        var name: String = ""
                
        for char in String(describing: rawValue) {
            if String(char) != String(char).uppercased() {
                name.append(String(char))
            } else {
                // add a space when we come to the camel-cased character
                name.append(" \(String(char))")
            }
        }
        
        return name.capitalized
    }
    
    var message: String {
        switch self {
        case .drink:
            return "I'm thirsty"
        case .food:
            return "I'm hungry"
        case .medication:
            return "I need medication(s)"
        }
    }
    
    var image: UIImage {
        switch self {
        case .drink:
            return UIImage.named(.drink)
        case .food:
            return UIImage.named(.food)
        case .medication:
            return UIImage.named(.medication)
        }
    }
    
    var viewModel: AlertViewModel {
        return AlertViewModel(
            title: self.description,
            message: self.message,
            image: image
        )
    }
}

enum CompanionType: String, CaseIterable, NeedType {
    case chat
    case important
    case spendTime
    
    var description: String {
        
        var name: String = ""
                
        for char in String(describing: rawValue) {
            if String(char) != String(char).uppercased() {
                name.append(String(char))
            } else {
                // add a space when we come to the camel-cased character
                name.append(" \(String(char))")
            }
        }
        
        return name.capitalized
    }
    
    var message: String {
        switch self {
        case .chat:
            return "Can we chat?"
        case .important:
            return "I have to tell you something important"
        case .spendTime:
            return "Can we spend time together?"
        }
    }
    
    var image: UIImage {
        switch self {
        case .chat:
            return UIImage.named(.chat)
        case .important:
            return UIImage.named(.important)
        case .spendTime:
            return UIImage.named(.spendTime)
        }
    }
    
    var viewModel: AlertViewModel {
        return AlertViewModel(
            title: self.description,
            message: self.message,
            image: image
        )
    }
    
}
