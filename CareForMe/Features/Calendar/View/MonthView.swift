//
//  MonthView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/12/21.
//

import UIKit

protocol DateChangeDelegate: AnyObject {
    var month: CalendarMonth { get set }
    var calView: CalendarView { get }
    func changeDate(direction: CalendarMonth.MonthDirection)
}

extension DateChangeDelegate {
    func changeDate(direction: CalendarMonth.MonthDirection) {
        month.changeDate(direction: direction)
        calView.dateCollectionView.collectionView.reloadData()
    }
}

class MonthView: UIView {
    private unowned var delegate: DateChangeDelegate!
    
    var month: CalendarMonth {
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
        button.addTarget(self, action: #selector(changeDate(_:)), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(changeDate(_:)), for: .touchUpInside)
        return button
    }()
    
    required init(_ month: CalendarMonth, delegate: DateChangeDelegate) {
        self.month = month
        self.delegate = delegate
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
    
    @objc private func changeDate(_ sender: UIButton) {
        if sender == leftButton {
            delegate.changeDate(direction: .backward)
        } else {
            delegate.changeDate(direction: .forward)
        }
        monthLabel.text = month.name
    }
}
