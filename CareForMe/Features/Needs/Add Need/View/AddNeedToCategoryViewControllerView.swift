//
//  AddNeedToCategoryViewControllerView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

class AddNeedToCategoryViewControllerView: UIView {
    var alertCategory: AlertCategory
    var presentPhotoTarget: Any?
    var presentPhotoSelector: Selector
    var selectedPhoto: NamedPhoto?
    
    lazy var alerts: [CareAlertType] = alertCategory.alerts {
        didSet {
            categoryCollectionView.reloadData()
        }
    }
    
    lazy var parentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [previewStack, titleStack, imageLabel, imageStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 20
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
    
    lazy var titleStack: UIStackView = .componentStack(elements: [titleLabel, titleTextField])
    
    lazy var titleLabel: UILabel = .title3Label(text: "Name")
    
//    lazy var titleLine: UIView = .separatorLine()
    
    lazy var titleTextField: UITextField = .borderedTextField(padding: 10, placeholderText: "Tap to Name This Need")
    
    lazy var imageStack: UIStackView = .componentStack(elements: [imageView, imageCaptionInstructionLabel], verticalAlignment: .center)
    
    lazy var imageLabel: UILabel = .title3Label(text: "Image")
    
    lazy var imageLine: UIView = .separatorLine()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        imageView.image = .stockImage(from: .firstAid)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var imageCaptionInstructionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .caption1, weight: .semibold)
        label.text = "tap image to change"
        return label
    }()
    
    lazy var buttonStack: UIStackView = {
        let stack: UIStackView = .componentStack(elements: [saveButton], horizontalAlignment: .bottom)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var addButton: UIButton = .fullWidthButton(with: "Add Need", color: .named(.secondaryLink), targetAndSelector: (self, #selector(addAlert)))
    lazy var saveButton: UIButton = .fullWidthButton(with: "Save Category and Quit")
    
    init(alertCategory: AlertCategory, photoPresentationTarget: Any?, photoPresentationSelector: Selector) {
        self.alertCategory = alertCategory
        self.presentPhotoTarget = photoPresentationTarget
        self.presentPhotoSelector = photoPresentationSelector
        super.init(frame: .zero)
        subviews()
        let tap = UITapGestureRecognizer(target: photoPresentationTarget, action: photoPresentationSelector)
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    func subviews() {
        addSubview(parentStack)
        addSubview(addButton)
        addSubview(buttonStack)
        constraints()
    }
    
    func constraints() {
        let bottomButtonConstraint = buttonStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40)
        bottomButtonConstraint.priority = .defaultHigh
        
        let parentBottomConstraint = parentStack.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -10)
        parentBottomConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            parentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            parentStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            parentStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),
            parentBottomConstraint,
            
            addButton.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: buttonStack.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor),
            
            buttonStack.trailingAnchor.constraint(equalTo: parentStack.safeAreaLayoutGuide.trailingAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: parentStack.safeAreaLayoutGuide.leadingAnchor),
            bottomButtonConstraint
            
            
        ])
    }
    
    @objc func addAlert() {
        let alert = CareAlertType(id: UUID(), category: alertCategory, stockPhotoName: selectedPhoto ?? .firstAid, title: titleTextField.text, message: "I'm hurt")
        alertCategory.alerts.append(alert)
        alerts = alertCategory.alerts
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
