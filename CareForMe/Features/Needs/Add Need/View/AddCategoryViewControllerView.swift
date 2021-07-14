//
//  AddCategoryViewControllerView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

class AddCategoryViewControllerView: UIView {
    var colorButtonTarget: Any
    var colorButtonSelector: Selector
    var alertCategory = AlertCategory(id: UUID(), color: .init(uiColor: .named(.highlight)), type: "Title Here") {
        didSet {
            categoryCollectionView.alertType = alertCategory
        }
    }
    
    weak var categoryUpdateDelegate: CategoryUpdatable?
    
    private lazy var parentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleStack, colorStack, previewStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    lazy var previewStack: UIStackView = .componentStack(elements: [previewLabel, previewLine, categoryCollectionView])
    
    lazy var previewLabel: UILabel = .title3Label(text: "Category Preview")
    
    lazy var previewLine: UIView = .separatorLine()
    
    lazy var categoryCollectionView: CareCollectionView = {
        let collectionView = CareCollectionView(alertType: alertCategory)
        collectionView.heightAnchor.constraint(equalToConstant: CareCollectionView.CareTypeLayout.heightConstant).isActive = true
        return collectionView
    }()
    
    private lazy var titleStack: UIStackView = .componentStack(elements: [titleInfoLabel, titleTextField])
    
    private lazy var titleInfoLabel: UILabel = .title3Label(text: "Title")
    
    private lazy var titleTextField: UITextField = .borderedTextField(placeholderText: "Tap to enter title")
    
    private lazy var colorStack: UIStackView = .componentStack(elements: [colorLabel, colorButton])
    
    private lazy var colorLabel: UILabel = .title3Label(text: "Background Color")
    
    private lazy var colorButton: UIButton = .fullWidthButton(with: "Change Background Color", color: .named(.secondaryLink), targetAndSelector: (colorButtonTarget, colorButtonSelector))
        
    
    private lazy var nextButton: UIButton = .fullWidthButton(with: "Next: Create Need(s)", targetAndSelector: (self, #selector(updateViewController)))
    
    init(target: Any, selector: Selector) {
        self.colorButtonTarget = target
        self.colorButtonSelector = selector
        super.init(frame: .zero)
        titleTextField.delegate = self
        colorButton.addTarget(target, action: selector, for: .touchUpInside)
        backgroundColor = .systemBackground
        subviews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(resignTextField))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
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
        categoryUpdateDelegate?.updateCategory(title: titleTextField.text)
    }
    
    func updateColors(basedOn color: UIColor) {
        let category = alertCategory
        category.color = .init(uiColor: color)
        alertCategory = category // this triggers didSet here which triggers didSet in the CollectionView's view
    }
    
}

extension AddCategoryViewControllerView: UITextFieldDelegate {
    /// called when view is tapped
    @objc private func resignTextField() {
        titleTextField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              !text.isEmpty
        else { return }

        let category = alertCategory
        
        category.title = text
        alertCategory = category // this triggers didSet here which triggers didSet in the CollectionView's view
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignTextField()
        return true
    }
    
}
