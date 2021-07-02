//
//  ViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/15/21.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var careCollectionView: AlertTypeCollectionView = {
        let collectionView = AlertTypeCollectionView(alertType: .care)
        return collectionView
    }()
    
    private lazy var companionCollectionView: AlertTypeCollectionView = {
        let collectionView = AlertTypeCollectionView(alertType: .companionship)
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

protocol NeedType: CustomStringConvertible {
    var description: String { get }
    var message: String { get }
    var image: UIImage { get }
    var viewModel: AlertViewModel { get }
    var rawValue: String { get }
}

protocol CareTypeCollectionViewDelegate: AnyObject {
    func didSelect(_ need: NeedType)
}

extension MainViewController: CareTypeCollectionViewDelegate {
    
    func didSelect(_ need: NeedType) {
        // post to user/notifications/
        print(need.rawValue)
    }
    
}

struct CareNotification: Codable {
    let title: String
    let text: String
    let forUserId: String
}
