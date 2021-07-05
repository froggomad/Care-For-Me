//
//  ViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var careCollectionView: AlertTypeCollectionView = {
        let careAlertCategory = AlertCategory(id: UUID(), color: UIColor.NamedColor.red.rawValue, type: "Care")
        let drinkAlert = CareAlertType(id: UUID(), category: careAlertCategory, title: "Drink", message: "I need water", image: UIImage.named(.drink).pngData() ?? Data())
        let foodAlert = CareAlertType(id: UUID(), category: careAlertCategory, title: "Food", message: "I need food", image: UIImage.named(.food).pngData() ?? Data())
        let medicationAlert = CareAlertType(id: UUID(), category: careAlertCategory, title: "Medication", message: "I need pills", image: UIImage.named(.medication).pngData() ?? Data())
        
        careAlertCategory.alerts = [drinkAlert, foodAlert, medicationAlert]
        
        let collectionView = AlertTypeCollectionView(alertType: careAlertCategory)
        return collectionView
    }()
    
    private lazy var companionCollectionView: AlertTypeCollectionView = {
        let companionAlertCategory = AlertCategory(id: UUID(), color: UIColor.NamedColor.yellow.rawValue, type: "Companionship")
        let timeAlert = CareAlertType(id: UUID(), category: companionAlertCategory, title: "Spend Time", message: "I want to spend time with you", image: UIImage.named(.spendTime).pngData() ?? Data())
        let chatAlert = CareAlertType(id: UUID(), category: companionAlertCategory, title: "Chat", message: "I want to talk", image: UIImage.named(.chat).pngData() ?? Data())
        let importantAlert = CareAlertType(id: UUID(), category: companionAlertCategory, title: "Important", message: "I need to talk about something important", image: UIImage.named(.important).pngData() ?? Data())
        
        companionAlertCategory.alerts = [timeAlert, chatAlert, importantAlert]
        let collectionView = AlertTypeCollectionView(alertType: companionAlertCategory)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setTab()
        careCollectionView.cellSelectDelegate = self
        companionCollectionView.cellSelectDelegate = self
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
        // post to user/notifications/
        print(need.title)
    }
    
}

struct CareNotification: Codable {
    let id: UUID
    let category: String
    let title: String
    let text: String
    let forUserId: String
    let date: Date
    
    var viewModel: NotificationCellViewModel {
        NotificationCellViewModel(category: category, title: title, message: text)
    }
}
