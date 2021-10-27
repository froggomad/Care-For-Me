//
//  DayDetailViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/24/21.
//

import UIKit

class DayDetailViewController: UIViewController, AuthenticableViewController, CalendarEventDelegate {
    private var day: Date
    var calendarEventController: CalendarEventController
    lazy var events = calendarEventController.events
    
    private lazy var dayDetailView: DayDetailView = .init(tableViewDelegate: self,
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
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func setupViews() {
        modalPresentationStyle = .fullScreen
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func addEvent() {
        let vc = EventDetailViewController(eventController: calendarEventController)
        navigationController?.pushViewController(vc, animated: true)
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
        events[day.dayDate()]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DayDetailTableViewCell.reuseIdentifier, for: indexPath) as! DayDetailTableViewCell
        cell.event = events[day.dayDate()]?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EventDetailViewController(eventController: calendarEventController, editMode: false, event: events[day.dayDate()]?[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
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
