//
//  DayDetailViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/24/21.
//

import UIKit

class DayDetailViewController: UIViewController, AuthenticableViewController, CalendarEventDelegate {
    var day: Date
    var calendarEventController: CalendarEventController
    lazy var events = calendarEventController.events
    
    lazy var dayDetailView: DayDetailView = .init(tableViewDelegate: self,
                                                  tableViewDataSource: self,
                                                  day: day,
                                                  navBarHeight: navigationController?.navigationBar.frame.height,
                                                  tabBarHeight: tabBarController?.tabBar.frame.height)
    
    init(day: Date, calendarEventController: CalendarEventController) {
        self.day = day
        self.calendarEventController = calendarEventController
        super.init(nibName: nil, bundle: nil)
        self.calendarEventController.delegate = self
        setupViews()
    }
    
    func update() {
        self.events = calendarEventController.events
        dayDetailView.tableView.reloadData()
    }
    
    private func setupViews() {
        modalPresentationStyle = .fullScreen
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func addEvent() {
        calendarEventController.saveEvent(CalendarEvent.mockEvent)
        dayDetailView.tableView.reloadData()
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
        self.view = dayDetailView
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
    func text(timeStyle: DateFormatter.Style = .none, dateStyle: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = timeStyle
        dateFormatter.dateStyle = dateStyle
        return dateFormatter.string(from: self)
    }
}
