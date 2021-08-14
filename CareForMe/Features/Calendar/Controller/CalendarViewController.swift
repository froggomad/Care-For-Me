//
//  CalendarViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/12/21.
//

import UIKit

class CalendarViewController: UIViewController {
    var month: CalendarMonth = .init()
    
    lazy var calView = CalendarView(month: month, collectionViewDelegate: self, collectionViewDataSource: self)
    
    override func loadView() {
        super.loadView()
        view = calView
    }
}

// MARK: - Collection View Conformance -
extension CalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numDays = month.numDaysInMonth[month.currentMonthIndex - 1] + month.firstWeekDayOfMonth - 1
        return numDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.reuseIdentifier, for: indexPath) as! DateCollectionViewCell
        
        if indexPath.item <= month.firstWeekDayOfMonth - 2 {
            cell.isHidden = true
        } else {
            cell.isHidden = false
            let calcDate = indexPath.item - month.firstWeekDayOfMonth + 2
            cell.text = "\(calcDate)"
            
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

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
}
