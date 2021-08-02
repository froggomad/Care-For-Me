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

class StockPhotoViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    var alert: AlertCategory = NamedPhoto.category
    var alerts: [CareAlertType]!
    lazy var filteredAlerts: [CareTypeable] = []
    weak var photoSelectionDelegate: StockPhotoImageSelectionDelegate?
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = false
        searchController.delegate = self
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    lazy var collectionView: CareCollectionView = {
        alert.alerts = NamedPhoto.allCases.map({$0.photoAlert}).sorted(by: {$0.title < $1.title})
        self.alerts = alert.alerts as? [CareAlertType] ?? []
        let collectionView = CareCollectionView(alertType: alert, layout: CareCollectionView.PhotoTypeLayout())
        collectionView.cellSelectDelegate = self
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        definesPresentationContext = true
        subviews()
    }
    
    private func subviews() {
        if !view.subviews.contains(collectionView) {
            view.addSubview(collectionView)
            constraints()
        }
        let navBarColor: UIColor = .tertiarySystemBackground
        if navigationItem.searchController == nil {
            navigationItem.searchController = searchController
            navigationController?.view.backgroundColor = navBarColor
        }
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

extension StockPhotoViewController: CareAlertSelectionDelegate {
    func didSelect(_ need: CareTypeable) {
        photoSelectionDelegate?.receivedImage(need.stockPhotoName.photoModel)
        if let navC = navigationController {
            navC.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

extension StockPhotoViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased(),
              !text.isEmpty else {
            collectionView.alertType = self.alert
            return
        }
        
        filteredAlerts = alerts.filter { $0.title.lowercased().contains(text) }.sorted(by: {$0.title < $1.title})
              
        collectionView.alertType?.alerts = filteredAlerts
        
        collectionView.reloadData()
    }
}
