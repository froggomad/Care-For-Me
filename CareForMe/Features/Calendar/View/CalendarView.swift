//
//  CalendarView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/12/21.
//

import UIKit

class CalendarView: UIView {
    var month: CalendarMonth {
        didSet {
            monthView.month = month
        }
    }
    private unowned var monthChangeDelegate: DateChangeDelegate!
    
    private unowned var delegate: UICollectionViewDelegate!
    private unowned var dataSource: UICollectionViewDataSource!
    
    private lazy var stack: UIStackView = {
        let stack: UIStackView = .componentStack(elements: [monthView, weekView], spacing: 20)
        return stack
    }()
    
    private lazy var monthView = MonthView(month, delegate: monthChangeDelegate)
    
    private lazy var weekView = WeekdayView()
    
    lazy var dateCollectionView: DateCollectionView = {
        let dateView = DateCollectionView(delegate: delegate, dataSource: dataSource)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        return dateView
    }()
        
    required init(month: CalendarMonth = .init(), collectionViewDelegate: UICollectionViewDelegate, collectionViewDataSource: UICollectionViewDataSource, monthChangeDelegate: DateChangeDelegate) {
        self.monthChangeDelegate = monthChangeDelegate
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
        let verticalPadding: CGFloat = 40
        let horizontalPadding: CGFloat = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            
            dateCollectionView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 10),
            dateCollectionView.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            dateCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding),
            dateCollectionView.leadingAnchor.constraint(equalTo: stack.leadingAnchor)
        ])
    }
    
}
