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

class StockPhotoViewController: UIViewController, AuthenticableViewController {
    
    var alert: AlertCategory = NamedPhoto.category
    var alerts: [CareAlertType]!
    lazy var filteredAlerts: [CareTypeable] = []
    weak var photoSelectionDelegate: StockPhotoImageSelectionDelegate?
    var searcher: SearchDelegate
    
    init(searchDelegate: SearchDelegate  = SearchDelegate()) {
        self.searcher = searchDelegate
        super.init(nibName: nil, bundle: nil)
        searcher.updater = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic View")
    }
    
    lazy var searchController: UISearchController = .init(with: searcher)
    
    lazy var collectionView: CareCollectionView = {
        alert.alerts = NamedPhoto.allCases.map({$0.photoAlert}).sorted(by: {$0.title < $1.title})
        self.alerts = alert.alerts as? [CareAlertType] ?? []
        let collectionView = CareCollectionView(alertType: alert, layout: CareCollectionView.PhotoTypeLayout())
        collectionView.cellSelectDelegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subviews()
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authenticate()
    }
    
    private func subviews() {
        view.addSubview(collectionView)
        constraints()
        
        let navBarColor: UIColor = .tertiarySystemBackground
    
        navigationItem.searchController = searchController
        navigationController?.view.backgroundColor = navBarColor
    
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    func searchBarCancelButtonClicked() {
        alert.alerts = alerts
        collectionView.reloadData()
    }
}

extension StockPhotoViewController: SearchableUpdatable {
    func search(with text: String) {
        guard !text.isEmpty else {
            alert.alerts = alerts
            collectionView.reloadData()
            return
        }
        
        filteredAlerts = alerts.filter { $0.title.lowercased().contains(text.lowercased()) }.sorted(by: {$0.title < $1.title})
        
        alert.alerts = filteredAlerts
        
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
