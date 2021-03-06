//
//  AddNeedToCategoryViewControllerView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

protocol AddNeedDelegate: AnyObject {
    func receivedNeed(_ need: CareTypeable)
}

class AddNeedToCategoryViewControllerView: UIView {
    var category: NeedsCategory

    var presentPhotoTarget: Any?
    var presentPhotoSelector: Selector
    
    weak var addNeedDelegate: AddNeedDelegate?
    
    var selectedPhoto: NamedPhoto! = .firstAid
    
    lazy var parentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleStack, messageStack, imageLabel, imageStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 20
        return stack
    }()
    
//    lazy var filledTitleStack: UIView = StatusTextField(type: .information, exampleText: "Example", textFieldPlaceholderText: "Placeholder", instructionText: "Instructions")
    
    lazy var titleStack: UIStackView = .componentStack(elements: [titleLabel, titleTextField])
    
    lazy var titleLabel: UILabel = .title3Label(text: "Name")
    
    lazy var titleTextField: UITextField = .borderedTextField(padding: 10, placeholderText: "Tap to Name This Need")
        
    
    lazy var messageStack: UIStackView = .componentStack(elements: [messageLabel, messageTextField])
    
    lazy var messageLabel: UILabel = .title3Label(text: "Message")
    
    lazy var messageTextField: UITextField = .borderedTextField(padding: 10, placeholderText: "Tap to add a default message.")
    
    
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
        
        imageView.image = selectedPhoto.image
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var imageCaptionInstructionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .caption1, weight: .semibold)
        label.text = "tap image to change"
        return label
    }()
    
    lazy var addButton: UIButton = .standardCFMButton(with: "Add Need", color: .named(.secondaryLink), targetAndSelector: TargetSelector(target: self, selector: #selector(addNeed(_:))))
    
    init(category: NeedsCategory, photoPresentationTarget: Any?, photoPresentationSelector: Selector, addNeedDelegate: AddNeedDelegate) {
        self.presentPhotoTarget = photoPresentationTarget
        self.presentPhotoSelector = photoPresentationSelector
        self.addNeedDelegate = addNeedDelegate
        self.category = category
        super.init(frame: .zero)
        titleTextField.delegate = self
        messageTextField.delegate = self
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        subviews()
        let tap = UITapGestureRecognizer(target: presentPhotoTarget, action: presentPhotoSelector)
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tap)
    }
    
    private func subviews() {
        addSubview(parentStack)
        addSubview(addButton)
        constraints()
    }
    
    func constraints() {
        let padding: CGFloat = 40
        NSLayoutConstraint.activate([
            parentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            parentStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            parentStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            
            addButton.trailingAnchor.constraint(equalTo: parentStack.trailingAnchor),
            addButton.topAnchor.constraint(equalTo: parentStack.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: parentStack.leadingAnchor)
        ])
    }
    
    @objc private func addNeed(_ sender: UIButton) {
        let title = titleTextField.text ?? ""
        let message = messageTextField.text ?? ""
        
        let need = Need(id: UUID(), category: category, stockPhotoName: selectedPhoto, title: title, message: message)
        addNeedDelegate?.receivedNeed(need)
    }
    
}

extension AddNeedToCategoryViewControllerView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case titleTextField:
            messageTextField.becomeFirstResponder()
        default:
            break
        }
        return true
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
