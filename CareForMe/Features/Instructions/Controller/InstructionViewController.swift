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
    var image: Gif?
    var caption: String?
    var buttonTitle: String
    var selectionDelegate: TargetSelector
    
    lazy var instructionView: InstructionView = InstructionView(title: titleText,
                                                                instructions: instructions,
                                                                imageFilename: image,
                                                                caption: caption,
                                                                buttonTitle: buttonTitle,
                                                                selectionDelegate: selectionDelegate)
    
    init(title: String, instructions: String, image: Gif?, caption: String? = nil, buttonTitle: String, selectionDelegate: TargetSelector) {
        self.titleText = title
        self.instructions = instructions
        self.image = image
        self.caption = caption
        self.buttonTitle = buttonTitle
        self.selectionDelegate = selectionDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    override func loadView() {
        view = instructionView
    }
    
}
