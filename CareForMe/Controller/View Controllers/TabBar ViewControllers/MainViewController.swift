//
//  ViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

class MainViewController: ParentDetailViewController {
    let needsController = NeedsController.shared
    
    func makeCareTypeCollectionViews() {
        for view in contentStack.arrangedSubviews {
            contentStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for category in NeedsController.shared.categories {
            let collectionView = CareCollectionView(alertType: category)
            collectionView.cellSelectDelegate = self
            collectionView.heightAnchor.constraint(equalToConstant: CareCollectionView.CareTypeLayout.heightConstant).isActive = true
            contentStack.addArrangedSubview(collectionView)
        }
    }
    
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
    
    lazy var parentStack: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [contentStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.alignment = .top
        return stackView
    }()
    
    lazy var contentStack: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setTab()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeCareTypeCollectionViews()
    }
    
    private func setupViews() {
        view.addSubview(addButton)
        view.addSubview(parentStack)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            parentStack.topAnchor.constraint(equalTo: addButton.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            parentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            parentStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            parentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }

}

protocol CareAlertSelectionDelegate: AnyObject {
    func didSelect(_ need: CareAlertType)
}

extension MainViewController: CareAlertSelectionDelegate {
    
    func didSelect(_ need: CareAlertType) {
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
