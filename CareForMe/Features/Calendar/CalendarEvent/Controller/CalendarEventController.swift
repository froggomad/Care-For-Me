//
//  CalendarEventController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/25/21.
//

import Foundation

protocol CalendarEventDelegate: AnyObject {
    var calendarEventController: CalendarEventController { get set }
    var events: [Date: [CalendarEvent]] { get set }
    func update()
}

extension CalendarEventDelegate {
    func update() {
        self.events = calendarEventController.events
    }
}

class CalendarEventController {
    let dbController = FirebaseDatabaseController()
    var events: [Date: [CalendarEvent]] = [:] {
        didSet {
            delegate?.update()
        }
    }
    weak var delegate: CalendarEventDelegate?
    
    init(delegate: CalendarEventDelegate? = nil) {
        self.delegate = delegate
        observeEventsFromAPI()
    }
    
    func saveEvent(_ event: CalendarEvent) {
        
        if events[event.date.dayDate()]?.isEmpty ?? true {
            events[event.date.dayDate()] = [event]
        } else {
            events[event.date.dayDate()]!.append(event)
        }
        
        sendEventToAPI(event) { error in
            print(error)
        }
        NotificationCenter.default.post(name: .eventsUpdated, object: nil)
    }
    
    func deleteEvent(_ event: CalendarEvent) {
        events[event.date]
        deleteEventFromAPI(event: event) { error in
            print(error)
        }
        NotificationCenter.default.post(name: .eventsUpdated, object: nil)
    }
    
    private func observeEventsFromAPI() {
        guard let user = AuthService.shared.user else { return }
        dbController.observe(ref: .eventRef(userId: user.privateDetails.userId)) { [weak self] snapshot in
            
            defer { NotificationCenter.default.post(name: .eventsUpdated, object: nil) }
            
            guard let self = self,
                  snapshot.exists()
            else {
                self?.events = [:]
                return
            }
            do {
                let events = try snapshot.data(as: [String: CalendarEvent].self)
                
                var dayEvents: [Date: [CalendarEvent]] = [:]
                
                events.forEach({
                    
                    let date = $1.date.dayDate()
                    
                    if dayEvents[date] != nil {
                        dayEvents[date]!.append($1)
                    } else {
                        dayEvents[date] = [$1]
                    }
                })
                self.events = dayEvents
            } catch {
                print(error)
            }
        }
    }
    
    private func sendEventToAPI(_ event: CalendarEvent, completion: @escaping (Error?) -> Void) {
        guard let user = AuthService.shared.user else { return }
        dbController.setUserValue(for: .eventRef(userId: user.privateDetails.userId), endpoint: event.id.uuidString, with: event)
    }
    
    private func deleteEventFromAPI(event: CalendarEvent, completion: @escaping (Error?) -> Void) {
        guard let user = AuthService.shared.user else { return }
        dbController.delete(ref: .eventRef(userId: user.privateDetails.userId), endpoint: event.id.uuidString) { error, _ in
            completion(error)
        }
    }
    
}

extension Notification.Name {
    static var eventsUpdated = Notification.Name(rawValue: "eventsUpdated")
}

extension Date {
    func dayDate() -> Date {
        let day = Calendar.current.dateComponents([.year, .day, .month], from: self)
        print(day)
        
        let dayComponents = DateComponents(calendar: .current, timeZone: .current, year: day.year, month: day.month, day: day.day)
        let date = dayComponents.date ?? Date()
        return date
    }
}
