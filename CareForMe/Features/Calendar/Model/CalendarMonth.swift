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
    /// represents current month
    var currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    /// represents month in view
    lazy var presentMonthIndex = currentMonthIndex
    /// represents current year
    var currentYear = Calendar.current.component(.year, from: Date())
    /// represents year in view
    lazy var presentYear = currentYear
    
    var todaysDate = Calendar.current.component(.day, from: Date())
    /// value should be 0-6 (Sunday through Saturday)
    lazy var firstWeekDayOfMonth = getFirstWeekDay()
    
    var name: String {
        Self.monthsArr[currentMonthIndex]
    }
    
    init() {
        calculateLeapYear()
    }
    
    private func getFirstWeekDay() -> Int {
        // currentMonthIndex is set to retrieve values from array
        // this needs to be +1 to match the actual month's integer value
        let day = ("\(currentYear)-\(currentMonthIndex + 1)-01".date?.firstDayOfTheMonth.weekday)!
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
