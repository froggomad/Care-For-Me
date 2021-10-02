//
//  DateFormatter+firebaseDate.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 9/28/21.
//

import Foundation

extension DateFormatter {
    static func firebaseStringFromDate(from dateString: String) -> String {
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        guard let isoDate = isoDateFormatter.date(from: dateString) else {
            print("invalid dateString passed into \(#function)")
            return "invalid date"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: isoDate)
    }
}
