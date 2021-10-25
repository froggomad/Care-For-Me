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
    private var tabBarHeight: CGFloat?
    private var navBarHeight: CGFloat?
    
    private let titleFont = UIFont.preferredFont(for: .title3, weight: .bold)
    private lazy var dayHeight = day.text().height(withConstrainedWidth: UIScreen.main.bounds.width, font: titleFont)
    
    required init(tableViewDelegate: UITableViewDelegate, tableViewDataSource: UITableViewDataSource, day: Date, navBarHeight: CGFloat?, tabBarHeight: CGFloat?) {
        self.day = day
        self.tabBarHeight = tabBarHeight
        self.navBarHeight = navBarHeight
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
        let label = UILabel()
        label.text = day.text()
        label.font = titleFont
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: dayHeight).isActive = true
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(DayDetailTableViewCell.self, forCellReuseIdentifier: DayDetailTableViewCell.reuseIdentifier)
        tv.dataSource = tableViewDataSource
        tv.delegate = tableViewDelegate
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        let uiItemsHeight = (navBarHeight ?? 0) + (tabBarHeight ?? 0)
        tv.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - dayHeight - uiItemsHeight - 20).isActive = true
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
