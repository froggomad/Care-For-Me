//
//  InstructionView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/7/21.
//

import UIKit
import JellyGif

class InstructionView: UIView {
    
    private var titleString: String
    private var instructions: String
    private var image: Gif
    private var caption: String?
    private var buttonTitle: String
    private var selectionDelegate: TargetSelector
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, instructionLabel, imageStack, button])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(for: .title1)
        label.text = titleString
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(for: .body, weight: .bold)
        label.text = instructions
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imageStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, captionLabel])
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    
    private lazy var imageView: JellyGifImageView = {
        let imageView = JellyGifImageView()
        imageView.frame.size.height = 100
        imageView.frame.size.width = imageView.frame.height
        imageView.contentMode = .scaleAspectFit
        imageView.startGif(with: .name(image.rawValue))
        return imageView
    }()
    
    private lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(for: .caption1, weight: .bold)
        label.text = caption
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.addTarget(selectionDelegate.target, action: selectionDelegate.selector, for: .touchUpInside)
        return button
    }()
    
    init(title: String, instructions: String, imageFilename: Gif, caption: String? = nil, buttonTitle: String, selectionDelegate: TargetSelector) {
        self.titleString = title
        self.instructions = instructions
        self.image = imageFilename
        self.caption = caption
        self.buttonTitle = buttonTitle
        self.selectionDelegate = selectionDelegate
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        subviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func subviews() {
        addSubview(mainStack)
        constraints()
    }
    
    private func constraints() {
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            mainStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            mainStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            mainStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
        ])
    }
    
}
