//
//  DayDetailViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/24/21.
//

import UIKit

class DayDetailViewController: UIViewController, AuthenticableViewController {
    var day: Date
    var events: [CalendarEvent]
    
    init(day: Date, events: [CalendarEvent]) {
        self.day = day
        self.events = events
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authenticate()
    }
    
    override func loadView() {
        super.loadView()
        let dayView = DayDetailView(tableViewDelegate: self, tableViewDataSource: self, day: day)
        self.view = dayView
    }
}

extension DayDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DayDetailTableViewCell.reuseIdentifier, for: indexPath) as! DayDetailTableViewCell
        cell.event = events[indexPath.row]
        return cell
    }
    
    
}

extension Date {
    func shortDateText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self)
    }
    
    func mediumDateText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }
}
