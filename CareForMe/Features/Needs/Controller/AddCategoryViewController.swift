//
//  AddCategoryViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/10/21.
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
//        {
//        let textField = UITextField()
//        textField.leftViewMode = .always
//        textField.rightViewMode = .always
//        textField.layer.masksToBounds = true
//
//        let leftPaddingView = UIView(frame: .init(x: 0, y: 0, width: 10, height: textField.frame.height))
//        let rightPaddingView = UIView(frame: .init(x: 0, y: 0, width: 10, height: textField.frame.height))
//        textField.leftView = leftPaddingView
//        textField.rightView = rightPaddingView
//
//        textField.layer.borderColor = UIColor.label.cgColor
//        textField.layer.borderWidth = 1
//        textField.placeholder = "Tap to enter title"
//        return textField
//    }()
    
    private lazy var colorStack: UIStackView = .componentStack(elements: [colorLabel, colorButton])
    
    private lazy var colorLabel: UILabel = .title3Label(text: "Background Color")
    
    private lazy var colorButton: UIButton = {
        let button = UIButton(type: .system)
        button.underlineTitle(text: "Change Background Color")
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

class AddCategoryViewController: UIViewController, CategoryUpdatable {
    
    lazy var categorySetupView: AddCategoryViewControllerView = {
        let view = AddCategoryViewControllerView(target: self, selector: #selector(presentColorChoice))
        view.categoryUpdateDelegate = self
        return view
    }()
    
    override func loadView() {
        view = categorySetupView
    }
    
    @objc func presentColorChoice() {
        let vc = ColorPickerViewController()
        vc.controllerDelegate = self
        present(vc, animated: true)
    }
    
    func createCategory(title: String?) {
        // call modelController and update view
        guard let title = title else {
            // TODO: present alert
            return
        }
        let category = NeedsCategory(title: title)
        let controller = NeedsController()
        
        controller.addCategory(category)
        print(controller.categories.count)
        // TODO: present StockImageViewController
    }
}

extension AddCategoryViewController: ColorPickerDelegate {
    func colorWasPicked(_ color: UIColor) {
        categorySetupView.updateColors(basedOn: color)
    }
}

protocol CategoryUpdatable: AnyObject {
    func createCategory(title: String?)
}

extension UILabel {
    static func title3Label(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = .preferredFont(for: .title3, weight: .bold)
        return label
    }
}

extension UIButton {
    func underlineTitle(text: String?) {
        guard let text = text else { return }
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: text, attributes: underlineAttribute)
        setAttributedTitle(underlineAttributedString, for: .normal)
    }
}

extension UIStackView {
    static func componentStack(elements: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: elements)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 2
        
        let horizontalStack = UIStackView(arrangedSubviews: [stack])
        horizontalStack.alignment = .top
        return horizontalStack
    }
}

extension UITextField {
    static func borderedTextField(padding: CGFloat = 10, borderColor: UIColor = .label, borderWidth: CGFloat = 1,  placeholderText: String? = nil, text: String? = nil) -> UITextField {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.layer.masksToBounds = true
        
        let leftPaddingView = UIView(frame: .init(x: 0, y: 0, width: padding, height: textField.frame.height))
        let rightPaddingView = UIView(frame: .init(x: 0, y: 0, width: padding, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.rightView = rightPaddingView
        textField.placeholder = placeholderText
        textField.text = text
        
        textField.layer.borderColor = borderColor.cgColor
        textField.layer.borderWidth = borderWidth
        return textField
    }
}
