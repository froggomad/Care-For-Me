//
//  AddCategoryViewControllerView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

class AddCategoryViewControllerView: UIView {
    var colorButtonTarget: Any?
    var colorButtonSelector: Selector
    
    weak var categoryUpdateDelegate: CategoryUpdatable?
    
    private lazy var parentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleStack, colorStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var titleStack: UIStackView = .componentStack(elements: [titleInfoLabel, titleTextField])
    
    private lazy var titleInfoLabel: UILabel = .title3Label(text: "Title")
    
    private lazy var titleTextField: UITextField = .borderedTextField(placeholderText: "Tap to enter title")
    
    private lazy var colorStack: UIStackView = .componentStack(elements: [colorLabel, colorButton])
    
    private lazy var colorLabel: UILabel = .title3Label(text: "Background Color")
    
    private lazy var colorButton: UIButton = {
        let button = UIButton(type: .system)
        button.underlinedTitle(with: "Change Background Color")
        button.addTarget(colorButtonTarget, action: colorButtonSelector, for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next: Create Need(s)", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(updateViewController), for: .touchUpInside)
        return button
    }()
    
    init(target: Any?, selector: Selector) {
        self.colorButtonTarget = target
        self.colorButtonSelector = selector
        super.init(frame: .zero)
        colorButton.addTarget(target, action: selector, for: .touchUpInside)
        backgroundColor = .systemBackground
        subviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func subviews() {
        addSubview(parentStackView)
        addSubview(nextButton)
        constraints()
    }
    
    private func constraints() {
        let padding: CGFloat = 40
        
        NSLayoutConstraint.activate([
            parentStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            parentStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            parentStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            nextButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            nextButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            parentStackView.bottomAnchor.constraint(greaterThanOrEqualTo: nextButton.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
    }
    
    @objc private func updateViewController() {
        categoryUpdateDelegate?.createCategory(title: titleTextField.text)
    }
    
    func updateColors(basedOn color: UIColor) {
        self.backgroundColor = color
        titleTextField.textColor = .contextualColor(for: color)
        titleTextField.layer.borderColor = UIColor.contextualColor(for: color).cgColor
        titleTextField.attributedPlaceholder = NSAttributedString(string: titleTextField.placeholder ?? "",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.contextualColor(for: color, lightColorToUse: .white, darkColorToUse: .systemGray)])
        titleInfoLabel.textColor = .contextualColor(for: color)
        colorLabel.textColor = .contextualColor(for: color)
        colorButton.setContextualLinkColor(for: color, lightColorToUse: .white, darkColorToUse: .link)
    }
    
}

