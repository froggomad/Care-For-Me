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
        let stack = UIStackView(arrangedSubviews: [titleStack, imageLabel, imageStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 20
        return stack
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
    
    lazy var addButton: UIButton = .fullWidthButton(with: "Add Need", color: .named(.secondaryLink), targetAndSelector: TargetSelector(target: self, selector: #selector(addNeed(_:))))
    
    init(category: NeedsCategory, photoPresentationTarget: Any?, photoPresentationSelector: Selector, addNeedDelegate: AddNeedDelegate) {
        self.presentPhotoTarget = photoPresentationTarget
        self.presentPhotoSelector = photoPresentationSelector
        self.addNeedDelegate = addNeedDelegate
        self.category = category
        super.init(frame: .zero)
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
        
        NSLayoutConstraint.activate([
            parentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            parentStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            parentStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),            
            
            addButton.trailingAnchor.constraint(equalTo: parentStack.trailingAnchor),
            addButton.topAnchor.constraint(equalTo: parentStack.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: parentStack.leadingAnchor)            
        ])
    }
    
    @objc private func addNeed(_ sender: UIButton) {
        let title = titleTextField.text ?? ""
        let need = Need(id: UUID(), category: category, stockPhotoName: selectedPhoto, title: title, message: "")
        addNeedDelegate?.receivedNeed(need)
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
