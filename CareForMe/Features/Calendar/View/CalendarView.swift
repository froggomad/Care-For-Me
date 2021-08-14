//
//  CalendarView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/12/21.
//

import UIKit

class CalendarView: UIView {
    private var month: CalendarMonth
    
    private unowned var delegate: UICollectionViewDelegate!
    private unowned var dataSource: UICollectionViewDataSource!
    
    private lazy var stack: UIStackView = {
        let stack: UIStackView = .componentStack(elements: [monthView, weekView], spacing: 20)
        return stack
    }()
    
    private lazy var monthView = MonthView(month)
    
    private lazy var weekView = WeekdayView()
    
    lazy var dateCollectionView: DateCollectionView = {
        let dateView = DateCollectionView(delegate: delegate, dataSource: dataSource)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        return dateView
    }()
        
    required init(month: CalendarMonth = .init(), collectionViewDelegate: UICollectionViewDelegate, collectionViewDataSource: UICollectionViewDataSource) {
        self.month = month
        super.init(frame: .zero)
        self.delegate = collectionViewDelegate
        self.dataSource = collectionViewDataSource
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(stack)
        addSubview(dateCollectionView)
        constraints()
    }
    
    private func constraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            dateCollectionView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 10),
            dateCollectionView.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            dateCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            dateCollectionView.leadingAnchor.constraint(equalTo: stack.leadingAnchor)
        ])
    }
    
}
