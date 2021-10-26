//
//  CalendarViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/12/21.
//

import UIKit

class CalendarViewController: UIViewController, DateChangeDelegate, AuthenticableViewController {
    
    var month: CalendarMonth = .init() {
        didSet {
            calView.month = month
        }
    }
    
    lazy var calView = CalendarView(month: month, collectionViewDelegate: self, collectionViewDataSource: self, monthChangeDelegate: self)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    override func loadView() {
        super.loadView()        
        view = calView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authenticate()
    }
    
    private func setTabBar() {
        self.title = "Calendar"
        self.tabBarItem.image = UIImage(systemName: "calendar")
        self.tabBarItem.selectedImage = UIImage(systemName: "calendar.fill")
    }
}

// MARK: - Collection View Conformance -
extension CalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCollectionViewCell
        if month.date(from: indexPath) >= Date() {
            cell.backgroundColor = .red
        }
        
        let vc = DayDetailViewController(day: month.date(from: indexPath), calendarEventController: CalendarEventController())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(month.date(from: indexPath))
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .clear
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numDays = month.numDaysInMonth[month.currentMonthIndex] + month.firstWeekDayOfMonth - 1
        return numDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.reuseIdentifier, for: indexPath) as! DateCollectionViewCell
        
        if indexPath.item <= month.firstWeekDayOfMonth - 2 {
            cell.isHidden = true
        } else {
            cell.isHidden = false
            let calcDate = month.day(from: indexPath)
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
        let width = collectionView.frame.width/7
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
}
