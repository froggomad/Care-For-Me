//
//  CalendarViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/12/21.
//

import UIKit

class CalendarViewController: UIViewController {
    var month: CalendarMonth!
    
    lazy var calView = CalendarView(month: month, collectionViewDelegate: self, collectionViewDataSource: self)
    
    override func loadView() {
        super.loadView()
        view = calView
    }
}

extension CalendarViewController: UICollectionViewDelegate {
    
}

extension CalendarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        month.numDaysInMonth[month.currentMonthIndex - 1] + month.firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.reuseIdentifier, for: indexPath) as! DateCollectionViewCell
        
        if indexPath.item <= month.firstWeekDayOfMonth - 2 {
            cell.isHidden = true
        } else {
            cell.isHidden = false
            let calcDate = indexPath.item - month.firstWeekDayOfMonth - 2
            cell.label.text = "\(calcDate)"
            
            if calcDate < month.todaysDate && month.currentYear == month.presentYear && month.currentMonthIndex == month.presentMonthIndex {
                cell.isUserInteractionEnabled = false
                cell.label.textColor = .lightGray
            } else {
                cell.isUserInteractionEnabled = true
                cell.label.textColor = .label
            }
        }
        
        return cell
    }
}
