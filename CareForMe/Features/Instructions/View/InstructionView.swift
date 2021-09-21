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
    private var image: Gif?
    private var caption: String?
    private var buttonTitle: String
    private var selectionDelegate: TargetSelector?
    
    private lazy var mainStack: UIStackView = {
        let stack: UIStackView = .componentStack(elements: [titleLabel, instructionLabel, imageStack, viewStack, button])
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(for: .body, weight: .bold)
        label.text = titleString
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(for: .body)
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
    
    private lazy var viewStack: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var imageView: JellyGifImageView = {
        let imageView = JellyGifImageView()
        imageView.frame.size.height = 100
        imageView.frame.size.width = imageView.frame.height
        imageView.contentMode = .scaleAspectFit
        if let image = image {
            imageView.startGif(with: .name(image.rawValue))
        }
        return imageView
    }()
    
    private lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(for: .caption1, weight: .bold)
        label.text = caption
        return label
    }()
    
    lazy var button: UIButton = {
        var button: UIButton
        
        if let selectionDelegate = selectionDelegate {
            let targetSelector = TargetSelector(target: selectionDelegate.target, selector: selectionDelegate.selector)
            button = .standardCFMButton(with: buttonTitle, targetAndSelector: targetSelector)
        } else {
            button = .standardCFMButton(with: buttonTitle)
        }
        return button
    }()
    
    init(title: String, instructions: String, imageFilename: Gif?, caption: String? = nil, buttonTitle: String, selectionDelegate: TargetSelector?) {
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
    
    func addView(_ view: UIView) {
        viewStack.addArrangedSubview(view)
    }
    
}
