//
//  CareNotificationTableViewCell.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/2/21.
//

import UIKit

class CareNotificationTableViewCell: UITableViewCell {
    static let identifier = "CareNotificationTableViewCell"
    
    var viewModel: NotificationCellViewModel? {
        didSet {
            self.categoryLabel.text = viewModel?.category
            self.titleLabel.text = viewModel?.title
            self.bodyLabel.text = viewModel?.message
        }
    }
    
    lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [categoryLabel, titleLabel, bodyLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .caption1, weight: .semibold)
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        return label
    }()
    
    override func prepareForReuse() {
        subviews()
    }
    
    private func subviews() {
        if !subviews.contains(labelStack) {
            addSubview(labelStack)
            constraints()
        }
    }
    
    private func constraints() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            labelStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            labelStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            labelStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            labelStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding)
        ])
    }
}
