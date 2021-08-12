//
//  OnboardingViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/11/21.
//

import UIKit

class OnboardingViewController: InstructionViewController {
    
    let indicatorTitle: String
    let id: Int
    
    init(id: Int, indicatorText: String, title: String, instructions: String, image: Gif?, caption: String? = nil, buttonTitle: String, selectionDelegate: TargetSelector, additionalViews: [UIView]) {
        
        self.indicatorTitle = indicatorText
        self.id = id
        super.init(title: title, instructions: instructions, image: image, buttonTitle: buttonTitle, selectionDelegate: selectionDelegate)
        instructionView.button.tag = id

        for view in additionalViews {
            instructionView.addView(view)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic ViewController")
    }
}
