//
//  InstructionViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/7/21.
//

import UIKit

class InstructionViewController: UIViewController {
    
    var titleText: String
    var instructions: String
    var image: UIImage
    var caption: String?
    var buttonTitle: String
    
    lazy var instructionView: InstructionView = {
        InstructionView(title: titleText,
                        instructions: instructions,
                        image: image,
                        caption: caption,
                        buttonTitle: buttonTitle,
                        target: self,
                        selector: #selector(openSettings)
        )
    }()
    
    init(title: String, instructions: String, image: UIImage, caption: String? = nil, buttonTitle: String) {
        self.titleText = title
        self.instructions = instructions
        self.image = image
        self.caption = caption
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    override func loadView() {
        view = instructionView
    }
    
    @objc private func openSettings() {
        AppSettingsController.openSettings()
    }
    
}
