//
//  CalendarModel.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/12/21.
//

import Foundation

struct CalendarMonth {
    var numDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    /// represents current month
    var currentMonthIndex = Calendar.current.component(.month, from: Date())
    /// represents month in view
    lazy var presentMonthIndex = currentMonthIndex
    /// represents current year
    var currentYear = Calendar.current.component(.year, from: Date())
    /// represents year in view
    lazy var presentYear = currentYear
    
    var todaysDate = Calendar.current.component(.day, from: Date())
    /// value should be 0-6 (Sunday through Saturday)
    lazy var firstWeekDayOfMonth = getFirstWeekDay()
    
    private func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    mutating private func calculateLeapYear() {
        //for leap years, make february have 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numDaysInMonth[currentMonthIndex-1] = 29
        }
    }
    
    init() {
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
