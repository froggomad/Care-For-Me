//
//  ColorPickerView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/9/21.
//

import UIKit

class ColorPickerView: UIView {
    let buttonTargetSelector: TargetSelector
    let colorChangeTargetSelector: TargetSelector
    
    var color: UIColor = .systemBackground {
        didSet {
            colorPicker.color = color
        }
    }
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [informationLabel, colorPicker, button])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .title3, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Please choose a color by tapping and dragging the color wheel below."
        return label
    }()

    lazy var colorPicker: ColorPicker = {
        let picker = ColorPicker()
        let target = colorChangeTargetSelector.target
        let colorSelector = colorChangeTargetSelector.selector
        
        picker.addTarget(target, action: colorSelector, for: .valueChanged)
        picker.addTarget(self, action: #selector(setUIColors), for: .valueChanged)
        return picker
    }()

    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set Color", for: .normal)
        let buttonTarget = buttonTargetSelector.target
        let buttonAction = buttonTargetSelector.selector
        button.addTarget(buttonTarget, action: buttonAction, for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.frame.size.height = 50
        return button
    }()

    
    init(buttonTargetSelector: TargetSelector, colorTargetSelector: TargetSelector) {
        self.buttonTargetSelector = buttonTargetSelector
        self.colorChangeTargetSelector = colorTargetSelector
        super.init(frame: .zero)
        subviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func subviews() {
        addSubview(stackView)
        constraints()
    }
    
    private func constraints() {
        let padding:CGFloat = 20
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding)
        ])
    }
    
    @objc private func setUIColors() {
        let backgroundColor = backgroundColor ?? .black
        button.setContextualLinkColor()
        button.setContextualBackgroundColor(for: backgroundColor)
        
        informationLabel.setContextualTextColor(for: backgroundColor)
    }

}
