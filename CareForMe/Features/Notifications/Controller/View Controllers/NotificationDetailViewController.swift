//
//  NotificationDetailViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/4/21.
//

import UIKit

class NotificationDetailViewController: UIViewController {
    // MARK: - Properties -
    var notification: CareNotification {
        didSet {
            displayNotification()
        }
    }
    // MARK: - Views -
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, textLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(for: .title2, weight: .bold)
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(for: .body, weight: .regular)
        return label
    }()
    // MARK: - Init -
    init(notification: CareNotification) {
        self.notification = notification
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    // MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    private func setupViews() {
        displayNotification()
        
        if !view.subviews.contains(scrollView) {
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            constraints()
        }
    }
    
    private func constraints() {
        let scrollViewPadding: CGFloat = 10
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: scrollViewPadding),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -scrollViewPadding),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -scrollViewPadding),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: scrollViewPadding),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func displayNotification() {
        title = notification.title
        titleLabel.text = notification.categoryTitle
        textLabel.text = notification.text
    }
    
}
