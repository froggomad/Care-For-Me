//
//  ColorPickerView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/9/21.
//

import UIKit

class ColorPickerView: UIView {
    let buttonTarget: Any?
    let buttonAction: Selector
    let colorChangeTarget: Any?
    let colorChangeAction: Selector
    
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
        picker.addTarget(colorChangeTarget, action: colorChangeAction, for: .valueChanged)
        picker.addTarget(self, action: #selector(setUIColors), for: .valueChanged)
        return picker
    }()

    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set Color", for: .normal)
        button.addTarget(buttonTarget, action: buttonAction, for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.frame.size.height = 50
        return button
    }()

    
    init(buttonTarget: Any?, buttonAction: Selector, colorChangeTarget: Any?, colorChangeAction: Selector) {
        self.buttonTarget = buttonTarget
        self.buttonAction = buttonAction
        self.colorChangeTarget = colorChangeTarget
        self.colorChangeAction = colorChangeAction
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
        button.setContextualLinkColor(for: backgroundColor)
        button.setContextualBackgroundColor(for: backgroundColor)
        
        informationLabel.setContextualTextColor(for: backgroundColor)
    }

}
