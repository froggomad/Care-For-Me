//
//  ViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

class MainViewController: ParentDetailViewController {
    var searcher: SearchDelegate = NeedsController.shared
    lazy var searchController: UISearchController = .init(with: searcher)
    let needsController = NeedsController.shared
    /// original categories from controller if any
    var categories: [NeedsCategory]!
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        let heightConstant: CGFloat = 60
        
        button.addTarget(self, action: #selector(presentAddNeed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .named(.link)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: heightConstant),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
        ])
        button.layer.cornerRadius = heightConstant/2
        
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = needsController
        tableView.delegate = self
        tableView.delaysContentTouches = false
        tableView.canCancelContentTouches = false
        tableView.register(AlertCategoryTableViewCell.self, forCellReuseIdentifier: AlertCategoryTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // create copy of existing categories
        var categories: [NeedsCategory] = []
        for category in needsController.categories {
            categories.append(NeedsCategory(id: category.id, title: category.title, alerts: category.alerts, color: category.color))
        }
        self.categories = categories
        
        searcher.updater = self
        needsController.cellSelectDelegate = self
        needsController.delegate = self
        navigationItem.searchController = searchController
        setTab()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc func presentAddNeed() {
        let vc = AddCategoryViewController()
        showDetailViewController(vc, sender: nil)
    }
    
    private func setTab() {
        self.title = "Needs"
        self.tabBarItem.image = UIImage(systemName: "square.grid.3x2")
        self.tabBarItem.selectedImage = UIImage(systemName: "square.grid.3x2.fill")
    }
    
    private func setupViews() {
        view.addSubview(addButton)
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: addButton.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }

}

protocol CareAlertSelectionDelegate: AnyObject {
    func didSelect(_ need: CareTypeable)
}

extension MainViewController: CareAlertSelectionDelegate {
    
    func didSelect(_ need: CareTypeable) {
        // TODO: use companion userId
        FirebaseMessagingController.shared.requestNotificationPermissions { enabled in
            switch enabled {
            case .success:
                break
            case let .failure(error):
                print("Error with notification permissions: \(error)")
            }
            FirebaseMessagingController.shared.postMessage(category: need.category.title, title: need.title, text: need.message, toUserId: AuthService.shared.user!.userId)
        }
    }
    
}

struct CareNotification: Codable, Equatable {
    let id: UUID
    let category: String
    let title: String
    let text: String
    let forUserId: String
    let date: Date
    
    static func ==(lhs: CareNotification, rhs: CareNotification) -> Bool {
        lhs.id == rhs.id
    }
    
    var viewModel: NotificationCellViewModel {
        NotificationCellViewModel(id: id, category: category, title: title, message: text)
    }
    
    var categoryTitle: String {
        "\(category): \(title)"
    }
    
    init(id: UUID, category: String, title: String, text: String, forUserId: String, date: Date) {
        self.id = id
        self.category = category
        self.title = title
        self.text = text
        self.forUserId = forUserId
        self.date = date
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CareCollectionView.CareTypeLayout.heightConstant
    }
}

extension MainViewController: NeedsSearchDelegate {
    /// append saved categories to search categories
    func receivedCategory(category: NeedsCategory) {
        categories.append(category)
    }
    
    func searchBarCancelButtonClicked() {
        needsController.categories = categories
        tableView.reloadData()
    }    
    
    func search(with text: String) {
        defer { tableView.reloadData() }
        
        guard !text.isEmpty else {
            needsController.categories = categories
            return
        }
        let filteredCategories = categories.filter{ $0.needs.filter { $0.title.lowercased().contains(text.lowercased()) }.isEmpty == false}
        needsController.categories = filteredCategories
    }
    
}
