//
//  ViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var careCollectionView: AlertTypeCollectionView = {
        let careAlertCategory = AlertCategory(id: UUID(), color: .red, type: "Care")
        let drinkAlert = CareAlert(id: UUID(), category: careAlertCategory, title: "Drink", message: "I need water", date: Date(), image: .named(.drink))
        let foodAlert = CareAlert(id: UUID(), category: careAlertCategory, title: "Food", message: "I need food", date: Date(), image: .named(.food))
        let medicationAlert = CareAlert(id: UUID(), category: careAlertCategory, title: "Medication", message: "I need pills", date: Date(), image: .named(.medication))
        
        careAlertCategory.alerts = [drinkAlert, foodAlert, medicationAlert]
        
        let collectionView = AlertTypeCollectionView(alertType: careAlertCategory)
        return collectionView
    }()
    
    private lazy var companionCollectionView: AlertTypeCollectionView = {
        let companionAlertCategory = AlertCategory(id: UUID(), color: .yellow, type: "Companionship")
        let timeAlert = CareAlert(id: UUID(), category: companionAlertCategory, title: "Spend Time", message: "I want to spend time with you", date: Date(), image: .named(.spendTime))
        let chatAlert = CareAlert(id: UUID(), category: companionAlertCategory, title: "Chat", message: "I want to talk", date: Date(), image: .named(.chat))
        let importantAlert = CareAlert(id: UUID(), category: companionAlertCategory, title: "Important", message: "I need to talk about something important", date: Date(), image: .named(.important))
        
        companionAlertCategory.alerts = [timeAlert, chatAlert, importantAlert]
        let collectionView = AlertTypeCollectionView(alertType: companionAlertCategory)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        careCollectionView.cellSelectDelegate = self
        companionCollectionView.cellSelectDelegate = self
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
    func didSelect(_ need: CareAlert)
}

extension MainViewController: CareTypeCollectionViewDelegate {
    
    func didSelect(_ need: CareAlert) {
        // post to user/notifications/
        print(need.title)
    }
    
}

struct CareNotification: Codable {
    let title: String
    let text: String
    let forUserId: String
}
