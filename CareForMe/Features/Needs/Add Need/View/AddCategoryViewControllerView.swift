//
//  AddCategoryViewControllerView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

class AddCategoryViewControllerView: UIView {
    var addNeedPresentationTargetSelector: TargetSelector
    var colorButtonTargetSelector: TargetSelector
    var alertCategory = NeedsCategory(id: UUID(), title: "Title Here", color: .init(uiColor: .named(.highlight))) {
        didSet {
            categoryCollectionView.alertType = alertCategory
        }
    }
    
    weak var categoryUpdateDelegate: CategoryUpdatable?
    
    private lazy var parentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleStack, colorStack, needStack, previewStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    lazy var previewStack: UIStackView = .componentStack(elements: [previewLabel, previewLine, categoryCollectionView])
    
    lazy var previewLabel: UILabel = .subHeadlineLabel(text: "Category Preview")
    
    lazy var previewLine: UIView = .separatorLine()
    
    lazy var categoryCollectionView: CareCollectionView = {
        let collectionView = CareCollectionView(alertType: alertCategory)
        collectionView.heightAnchor.constraint(equalToConstant: CareCollectionView.CareTypeLayout.heightConstant).isActive = true
        return collectionView
    }()
    
    private lazy var titleStack: UIStackView = .componentStack(elements: [titleInfoLabel, titleTextField])
    
    private lazy var titleInfoLabel: UILabel = .subHeadlineLabel(text: "Title")
    
    lazy var titleTextField: UITextField = .borderedTextField(placeholderText: "Tap to enter title")
    
    private lazy var colorStack: UIStackView = .componentStack(elements: [colorLabel, colorButton])
    
    private lazy var colorLabel: UILabel = .subHeadlineLabel(text: "Background Color")
    
    private lazy var colorButton: UIButton = .standardCFMButton(with: "Change Background Color", color: .named(.secondaryLink), targetAndSelector: colorButtonTargetSelector)
        
    private lazy var needStack: UIStackView = .componentStack(elements: [needLabel, needButton])
    
    lazy var needLabel: UILabel = .subHeadlineLabel(text: "Needs")
    
    private lazy var needButton: UIButton = .standardCFMButton(with: "Add Need", color: .named(.secondaryLink), targetAndSelector: addNeedPresentationTargetSelector)
    
    private lazy var nextButton: UIButton = .standardCFMButton(with: "Done", targetAndSelector: TargetSelector(target: self, selector: #selector(updateViewController)))
    
    init(addNeedPresentationTargetSelector: TargetSelector, colorButtonTargetSelector: TargetSelector, delegate: CategoryUpdatable) {
        self.addNeedPresentationTargetSelector = addNeedPresentationTargetSelector
        self.categoryUpdateDelegate = delegate
        self.colorButtonTargetSelector = colorButtonTargetSelector
        super.init(frame: .zero)        
        setupViews()
    }
    
    private func setupViews() {
        titleTextField.delegate = self
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
