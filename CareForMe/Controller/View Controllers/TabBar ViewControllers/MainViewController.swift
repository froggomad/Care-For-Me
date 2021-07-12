//
//  ViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var careCollectionView: AlertTypeCollectionView = {
        let careAlertCategory = AlertCategory(id: UUID(), color: .init(uiColor: .red), type: "Play")
        let catAlert = CareAlertType(id: UUID(), category: careAlertCategory, stockPhotoName: .cat, title: "Play with cat", message: "I want to play with the cat")
        let chessAlert = CareAlertType(id: UUID(), category: careAlertCategory, stockPhotoName: .chess, message: "I want to play chess")
        let gardeningAlert = CareAlertType(id: UUID(), category: careAlertCategory, stockPhotoName: .flower, title: "Gardening", message: "I want to do some gardening")
        
        
        careAlertCategory.alerts = [catAlert, chessAlert, gardeningAlert]
        
        let collectionView = AlertTypeCollectionView(alertType: careAlertCategory)
        return collectionView
    }()
    
    private lazy var companionCollectionView: AlertTypeCollectionView = {
        let companionAlertCategory = AlertCategory(id: UUID(), color: .init(uiColor: .yellow), type: "Help")
        let callDoctorAlert = CareAlertType(id: UUID(), category: companionAlertCategory, stockPhotoName: .callDoctor, message: "I don't feel good. Please call the doctor for me")
        let coughAlert = CareAlertType(id: UUID(), category: companionAlertCategory, stockPhotoName: .cough, title: "I'm Coughing", message: "I'm coughing. I don't feel good")
        let medicationAlert = CareAlertType(id: UUID(), category: companionAlertCategory, stockPhotoName: .pill, title: "Need Pills", message: "I need to take medication")
        
        companionAlertCategory.alerts = [callDoctorAlert, coughAlert, medicationAlert]
        let collectionView = AlertTypeCollectionView(alertType: companionAlertCategory)
        return collectionView
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
        careCollectionView.cellSelectDelegate = self
        companionCollectionView.cellSelectDelegate = self
        let vc = AddCategoryViewController()
        present(vc, animated: true)
    }
    
    private func setTab() {
        self.title = "Needs"
        self.tabBarItem.image = UIImage(systemName: "square.grid.3x2")
        self.tabBarItem.selectedImage = UIImage(systemName: "square.grid.3x2.fill")
    }
    
    private func setupViews() {
        view.addSubview(careCollectionView)
        view.addSubview(companionCollectionView)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            careCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            careCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            careCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            careCollectionView.heightAnchor.constraint(equalToConstant: AlertTypeCollectionView.Layout.heightConstant + 20),
            
            companionCollectionView.topAnchor.constraint(equalTo: careCollectionView.bottomAnchor, constant: 20),
            companionCollectionView.heightAnchor.constraint(equalToConstant: AlertTypeCollectionView.Layout.heightConstant + 20),
            companionCollectionView.leadingAnchor.constraint(equalTo: careCollectionView.leadingAnchor),
            companionCollectionView.trailingAnchor.constraint(equalTo: careCollectionView.trailingAnchor)
        ])
    }

}

protocol CareTypeCollectionViewDelegate: AnyObject {
    func didSelect(_ need: CareAlertType)
}

extension MainViewController: CareTypeCollectionViewDelegate {
    
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
