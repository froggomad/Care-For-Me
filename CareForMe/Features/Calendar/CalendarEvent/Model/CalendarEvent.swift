//
//  CalendarEvent.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/25/21.
//

import Foundation

struct CalendarEvent: Codable, Equatable {
    let id: UUID
    let title: String
    var notes: String?
    let date: Date
    let duration: TimeInterval
    
    static let mockEvent = Self.init(id: UUID(), title: "Mock Event", notes: "Some Notes\n2nd line\n3rd line", date: Date(), duration: 30)
}
