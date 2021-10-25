//
//  DayDetailView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/24/21.
//

import UIKit

class DayDetailView: UIView {
    let day: Date
    weak var tableViewDataSource: UITableViewDataSource?
    weak var tableViewDelegate: UITableViewDelegate?
    
    required init(tableViewDelegate: UITableViewDelegate, tableViewDataSource: UITableViewDataSource, day: Date) {
        self.day = day
        super.init(frame: .zero)
        self.tableViewDelegate = tableViewDelegate
        self.tableViewDataSource = tableViewDataSource
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    lazy var stack: UIStackView = {
        let stack = UIStackView.componentStack(elements: [titleLabel, tableView], spacing: 10)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.headlineLabel(text: "\(day.mediumDateText())")
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(DayDetailTableViewCell.self, forCellReuseIdentifier: DayDetailTableViewCell.reuseIdentifier)
        tv.dataSource = tableViewDataSource
        tv.delegate = tableViewDelegate
        tv.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - 120).isActive = true
        return tv
    }()
    
    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(stack)
        constraints()
    }
    
    private func constraints() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding)
        ])
    }
}

struct CalendarEvent {
    let title: String
    var notes: String?
    let date: Date
    let duration: TimeInterval
    
    static let mockEvent = Self.init(title: "Mock Event", notes: "Some Notes\n2nd line\n3rd line", date: Date(), duration: 30) 
}

class DayDetailTableViewCell: UITableViewCell {
    static let reuseIdentifier = "DayDetailTableViewCell"
    var event: CalendarEvent? {
        didSet {
            setLabels()
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView.componentStack(elements: [titleLabel, notesLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel.headlineLabel(text: event?.title)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var notesLabel: UILabel = {
        let label = UILabel.bodyLabel(text: event?.notes)
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func setLabels() {
        titleLabel.text = event?.title
        notesLabel.text = event?.notes
    }
    
    private func setupViews() {
        if !subviews.contains(stackView) {
            setLabels()
            addSubview(stackView)
            constraints()
        }
    }
    
    private func constraints() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding)
        ])
    }
}
