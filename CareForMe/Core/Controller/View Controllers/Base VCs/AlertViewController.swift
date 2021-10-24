//
//  AlertViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 9/17/21.
//

import UIKit

protocol AlertControllerDelegate: AnyObject {
    func dismissMe()
}

class AlertViewController: UIViewController, AlertControllerDelegate {
    var yesNoMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }
    
    func present(title: String, message: String, handler: @escaping (Bool) -> Void) {
        
        let alertView = AlertView(title: title, message: message, yesNoMode: yesNoMode, closure: handler)
        alertView.delegate = self
        view.addSubview(alertView)
        NSLayoutConstraint.activate([
            alertView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            alertView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            alertView.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -20),
            alertView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    func dismissMe() {
        self.dismiss(animated: true, completion: nil)
    }
}

class AlertView: UIView {
    var closure: (Bool) -> Void
    var yesNoMode: Bool
    
    weak var delegate: AlertControllerDelegate!
    
    init(title: String, message: String, yesNoMode: Bool = false, closure: @escaping (Bool) -> Void) {
        self.closure = closure
        self.yesNoMode = yesNoMode
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        messageLabel.text = message
        layer.cornerRadius = 10
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("This is a programmatic view")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(for: .title1, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(for: .body, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private lazy var okButton: UIButton = {
        let button = button()
        
        if yesNoMode {
            button.setTitle("Yes", for: .normal)
        } else {
            button.setTitle("Ok", for: .normal)
        }
        
        button.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var noButton: UIButton = {
        let button = button()
        button.setTitle("No", for: .normal)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private func button() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .link
        button.tintColor = .white
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 1
        button.layer.cornerRadius = 10
        button.widthAnchor.constraint(equalToConstant: 75).isActive = true
        return button
    }
    
    lazy var separatorLine: UIView = {
        let line = UIView()
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.backgroundColor = .label
        return line
    }()
    
    lazy var titleStackView: UIStackView = {
        let stack: UIStackView = .componentStack(elements: [titleLabel, separatorLine])
        stack.spacing = 8
        return stack
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [okButton])
        stack.distribution = .equalSpacing
        stack.spacing = 16
        return stack
    }()
    
    lazy var parentStackView: UIStackView = {
        let stack: UIStackView = .componentStack(elements: [titleStackView, messageLabel, buttonStackView], spacing: 20)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func layout() {
        if yesNoMode {
            buttonStackView.addArrangedSubview(noButton)
        }
        addSubview(parentStackView)
        constraints()
    }
    
    func constraints() {
        let innerSpacing: CGFloat = 8
        let outerSpacing: CGFloat = 40
        
        NSLayoutConstraint.activate([
            parentStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: innerSpacing*2),
            parentStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -outerSpacing),
            parentStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -innerSpacing*2),
            parentStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: outerSpacing)
        ])
    }
    
    @objc private func okTapped() {
        delegate?.dismissMe()
        closure(true)
    }
    
    @objc private func cancelTapped() {
        delegate?.dismissMe()
        closure(false)
    }
    
}
