//
//  UILabel+title3Label.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

extension UILabel {
    static func title3Label(text: String?, weight: UIFont.Weight = .bold) -> UILabel {
        careForMeLabel(text: text, preferred: .title3, weight: weight)
    }
    
    static func headlineLabel(text: String?, weight: UIFont.Weight = .bold) -> UILabel {
        careForMeLabel(text: text, preferred: .headline, weight: weight)
    }
    
    static func subHeadlineLabel(text: String?, weight: UIFont.Weight = .bold) -> UILabel {
        careForMeLabel(text: text, preferred: .subheadline, weight: weight)
    }
    
    static func captionLabel(text: String?, weight: UIFont.Weight = .semibold) -> UILabel {
        careForMeLabel(text: text, preferred: .caption1, weight: weight)
    }
    
    static func bodyLabel(text: String?, weight: UIFont.Weight = .regular) -> UILabel {
        careForMeLabel(text: text, preferred: .body, weight: weight)
    }
    
    private static func careForMeLabel(text: String?, preferred font: UIFont.TextStyle, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = .preferredFont(for: font, weight: weight)
        return label
    }
}
