//
//  MonthView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/12/21.
//

import UIKit

class MonthView: UIView {
    
    private var month: CalendarMonth {
        didSet {
            monthLabel.text = month.name
        }
    }
    
    private lazy var hStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [leftButton, monthLabel, rightButton])
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.distribution = .fillEqually
        hStack.alignment = .center
        return hStack
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.init(systemName: "chevron.left.circle.fill"), for: .normal)
        return button
    }()
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = month.name
        label.font = .preferredFont(for: .body, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.init(systemName: "chevron.right.circle.fill"), for: .normal)
        return button
    }()
    
    required init(_ month: CalendarMonth) {
        self.month = month
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func setupViews() {
        addSubview(hStack)
        constraints()
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            hStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
        ])
    }
}
