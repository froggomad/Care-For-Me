//
//  CalendarModel.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/12/21.
//

import Foundation

struct CalendarMonth {
    enum MonthDirection {
        case forward
        case backward
    }
    
    static let monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    static let daysArr = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    
    var numDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    /// represents month view is set to
    var currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    /// represents current month from today's date
    lazy var presentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    /// represents year view is set to
    var currentYear = Calendar.current.component(.year, from: Date())
    /// represents the year from today's date
    lazy var presentYear = Calendar.current.component(.year, from: Date())
    
    var todaysDate = Calendar.current.component(.day, from: Date())
    /// value should be 0-6 (Sunday through Saturday)
    lazy var firstWeekDayOfMonth = getFirstWeekDay()
    
    private var month: Int {
        currentMonthIndex + 1
    }
    
    func date(from indexPath: IndexPath) -> Date {
        let date = date(from: day(from: indexPath))
        return date
    }
    
    func day(from indexPath: IndexPath) -> Int {
        indexPath.item - getFirstWeekDay() + 2
    }
    
    private func date(from day: Int) -> Date {
        let date = Calendar.current.date(from: DateComponents(year: currentYear, month: month, day: day))
        return date ?? Date()
    }
    
    var name: String {
        "\(Self.monthsArr[currentMonthIndex]) \(currentYear)"
    }
    
    init() {
        calculateLeapYear()
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(month)-01".date?.firstDayOfTheMonth.weekday)!
        return day
    }
    
    mutating private func calculateLeapYear() {
        //for leap years, make february have 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numDaysInMonth[currentMonthIndex-1] = 29
        }
    }
    
    mutating func changeDate(direction: MonthDirection) {
        switch direction {
        case .forward:
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        case .backward:
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        }
        firstWeekDayOfMonth = getFirstWeekDay()
        calculateLeapYear()
    }
    
}

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
