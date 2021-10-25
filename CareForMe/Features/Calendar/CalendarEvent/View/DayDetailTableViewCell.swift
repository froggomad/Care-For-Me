//
//  DayDetailTableViewCell.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/25/21.
//

import UIKit

class DayDetailTableViewCell: UITableViewCell {
    static let reuseIdentifier = "DayDetailTableViewCell"
    var event: CalendarEvent? {
        didSet {
            setLabels()
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView.componentStack(elements: [titleLabel, notesLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel.headlineLabel(text: event?.title)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var notesLabel: UILabel = {
        let label = UILabel.bodyLabel(text: event?.notes)
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func setupViews() {
        if !subviews.contains(stackView) {
            addSubview(stackView)
        }
        setLabels()
        constraints()
    }
    
    private func setLabels() {
        titleLabel.text = event?.title
        notesLabel.text = event?.notes
    }
    
    private func constraints() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding)
        ])
    }
}
