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
    
    var isSearching = false
    
    var alert: AlertCategory = NamedPhoto.category
    var alerts: [CareAlertType]!
    lazy var filteredAlerts: [CareTypeable] = []
    weak var photoSelectionDelegate: StockPhotoImageSelectionDelegate?
    
    lazy var searchController: UISearchController = .init(with: self)
    
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
    
    func willDismissSearchController(_ searchController: UISearchController) {
        isSearching = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        alert.alerts = alerts
        collectionView.reloadData()
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
        guard isSearching else { return }
        
        guard let text = searchController.searchBar.text?.lowercased(),
              !text.isEmpty else {
            alert.alerts = alerts
            collectionView.reloadData()
            return
        }
        
        filteredAlerts = alerts.filter { $0.title.lowercased().contains(text) }.sorted(by: {$0.title < $1.title})
              
        alert.alerts = filteredAlerts
        
        collectionView.reloadData()
    }
    
}
