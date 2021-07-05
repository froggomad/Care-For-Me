//
//  NotificationDetailViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/4/21.
//

import UIKit

class NotificationDetailViewController: UIViewController {
    var notification: CareNotification {
        didSet {
            displayNotification()
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, textLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(for: .title1, weight: .bold)
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(for: .body, weight: .regular)
        return label
    }()
    
    init(notification: CareNotification) {
        self.notification = notification
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    private func setupViews() {
        if !view.subviews.contains(stackView) {
            view.addSubview(stackView)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: stackView.frame.width, height: stackView.frame.height - titleLabel.frame.height - textLabel.frame.height))
            stackView.addArrangedSubview(view)
            constraints()
        }
        displayNotification()
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
    }
    
    private func displayNotification() {
        title = notification.title
        titleLabel.text = notification.categoryTitle
        textLabel.text = notification.text
    }
    
    
}
