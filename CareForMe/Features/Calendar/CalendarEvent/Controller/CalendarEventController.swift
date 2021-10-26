//
//  CalendarEventController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/25/21.
//

import Foundation

protocol CalendarEventDelegate: AnyObject {
    var calendarEventController: CalendarEventController { get set }
    var events: [CalendarEvent] { get set }
    func update()
}

extension CalendarEventDelegate {
    func update() {
        self.events = calendarEventController.events
    }
}

class CalendarEventController {
    let dbController = FirebaseDatabaseController()
    var events: [CalendarEvent] {
        didSet {
            delegate?.update()
        }
    }
    weak var delegate: CalendarEventDelegate?
    
    init(events: [CalendarEvent] = [], delegate: CalendarEventDelegate? = nil) {
        self.events = events
        self.delegate = delegate
        observeEventsFromAPI()
    }
    
    func saveEvent(_ event: CalendarEvent) {
        events.append(event)
        sendEventToAPI(event) { error in
            print(error)
        }
        NotificationCenter.default.post(name: .eventsUpdated, object: nil)
    }
    
    func deleteEvent(_ event: CalendarEvent) {
        events.removeAll(where: { $0 == event })
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
                self?.events = []
                return
            }
            do {
                let events = try snapshot.data(as: [String: CalendarEvent].self)
                self.events = Array(events.values)
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
