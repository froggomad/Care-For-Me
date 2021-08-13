//
//  CalendarView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/12/21.
//

import UIKit

class CalendarView: UIView {
    private let month = CalendarMonth()
    
    private lazy var monthView = MonthView(month.currentMonthIndex)
    
    private lazy var weekView = WeekdayView()
    
    lazy var dateCollectionView = DateCollectionView(delegate: delegate, dataSource: dataSource)
    
    private unowned var delegate: UICollectionViewDelegate!
    private unowned var dataSource: UICollectionViewDataSource!
    
    
    required init(collectionViewDelegate: UICollectionViewDelegate, collectionViewDataSource: UICollectionViewDataSource) {
        super.init(frame: .zero)
        self.delegate = collectionViewDelegate
        self.dataSource = collectionViewDataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
}
