//
//  CalendarView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/12/21.
//

import UIKit

class CalendarView: UIView {
    private var month: CalendarMonth
    
    private lazy var stack: UIStackView = .componentStack(elements: [monthView, weekView, dateCollectionView])
    
    private lazy var monthView = MonthView(month)
    
    private lazy var weekView = WeekdayView()
    
    lazy var dateCollectionView = DateCollectionView(delegate: delegate, dataSource: dataSource)
    
    private unowned var delegate: UICollectionViewDelegate!
    private unowned var dataSource: UICollectionViewDataSource!
    
    
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
        addSubview(stack)
        constraints()
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40)
        ])
    }
    
}
