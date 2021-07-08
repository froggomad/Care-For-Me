//
//  InstructionView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/7/21.
//

import UIKit

class InstructionView: UIView {
    
    private var titleString: String
    private var instructions: String
    private var image: UIImage
    private var caption: String?
    private var buttonTitle: String
    private var target: Any?
    private var selector: Selector
    
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
        label.font = .preferredFont(for: .title1)
        label.text = titleString
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
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
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame.size.height = 200
        imageView.frame.size.width = imageView.frame.height
        return imageView
    }()
    
    private lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .caption1, weight: .bold)
        label.text = caption
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.addTarget(target, action: selector, for: .touchUpInside)
        return button
    }()
    
    init(title: String, instructions: String, image: UIImage, caption: String? = nil, buttonTitle: String, target: Any, selector: Selector) {
        self.titleString = title
        self.instructions = instructions
        self.image = image
        self.caption = caption
        self.buttonTitle = buttonTitle
        self.target = target
        self.selector = selector
        super.init(frame: UIApplication.shared.windows.first?.frame ?? .zero)
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
