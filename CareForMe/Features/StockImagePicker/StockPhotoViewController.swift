//
//  StocImageViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/12/21.
//

import UIKit

protocol StockPhotoImageSelectionDelegate: AnyObject {
    /// - SUGGESTION: Use `didSet` pattern
    var selectedImage: StockPhoto? { get set }
    func receivedImage(_ image: StockPhoto)
}

extension StockPhotoImageSelectionDelegate {
    func receivedImage(_ image: StockPhoto) {
        selectedImage = image
    }
}
// TODO: Implement
class StockPhotoViewController: UIViewController {
    weak var photoSelectionDelegate: StockPhotoImageSelectionDelegate?
    var alert: AlertCategory = NamedPhoto.category
    
    lazy var collectionView: CareCollectionView = {
        alert.alerts.append(contentsOf: NamedPhoto.allCases.map({$0.photoAlert}).sorted(by: {$0.title < $1.title}))
        let collectionView = CareCollectionView(alertType: alert, layout: CareCollectionView.PhotoTypeLayout())
        collectionView.cellSelectDelegate = self
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subviews()
    }
    
    private func subviews() {
        view.addSubview(collectionView)
        constraints()
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}

extension StockPhotoViewController: CareTypeCollectionViewDelegate {
    func didSelect(_ need: CareAlertType) {
        photoSelectionDelegate?.receivedImage(need.stockPhotoName.photoModel)
        if let navC = navigationController {
            navC.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
