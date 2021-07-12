//
//  AddNeedToCategoryViewControllerView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

class AddNeedToCategoryViewControllerView: UIView {
    var alertCategory: AlertCategory
    lazy var alerts: [CareAlertType] = alertCategory.alerts {
        didSet {
            categoryCollectionView.reloadData()
        }
    }
    
    lazy var parentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [previewStack, titleStack])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var previewStack: UIStackView = .componentStack(elements: [previewLabel, line, categoryCollectionView])
    
    lazy var previewLabel: UILabel = .title3Label(text: "Category Preview")
    
    lazy var line: UIView = .separatorLine()
    
    lazy var categoryCollectionView: AlertTypeCollectionView = {
        let collectionView = AlertTypeCollectionView(alertType: alertCategory)
        collectionView.heightAnchor.constraint(equalToConstant: AlertTypeCollectionView.Layout.heightConstant).isActive = true
        return collectionView
    }()
    
    lazy var titleStack: UIStackView = .componentStack(elements: [titleLabel, titleTextField])
    
    lazy var titleLabel: UILabel = .title3Label(text: "Name")
    lazy var titleTextField: UITextField = .borderedTextField(padding: 10, borderColor: .contextualColor(for: backgroundColor ?? .black), borderWidth: 1, placeholderText: "Tap to Name This Need", text: nil)
    
    init(alertCategory: AlertCategory) {
        self.alertCategory = alertCategory
        super.init(frame: .zero)
        subviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    func subviews() {
        addSubview(parentStack)
        constraints()
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            parentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            parentStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            parentStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            parentStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40)
            
        ])
    }
    
    @objc func addAlert() {
        let alert = CareAlertType(id: UUID(), category: alertCategory, stockPhotoName: .ambulance, title: titleLabel.text, message: "I need an ambulance!")
        alertCategory.alerts.append(alert)
    }
}

extension UIView {
    static func separatorLine(height: CGFloat = 1) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.backgroundColor = .black
        view.layer.borderWidth = height
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }
}
