//
//  InstructionView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/7/21.
//

import UIKit

class InstructionView: UIView {
    
    private var title: String
    private var instructions: String
    private var image: UIImage
    private var caption: String?
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, instructionLabel, imageStack])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .title1)
        label.text = title
        return label
    }()
    
    lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .body, weight: .bold)
        label.text = instructions
        return label
    }()
    
    lazy var imageStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, captionLabel])
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .center
        return stack
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = image
        return imageView
    }()
    
    lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .caption1, weight: .bold)
        label.text = caption
        return label
    }()
    
    init(title: String, instructions: String, image: UIImage, caption: String? = nil) {
        self.title = title
        self.instructions = instructions
        self.image = image
        self.caption = caption
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
}
