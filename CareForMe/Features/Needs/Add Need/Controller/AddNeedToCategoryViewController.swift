//
//  AddNeedToCategoryViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

class AddNeedToCategoryViewController: ParentDetailViewController, StockPhotoImageSelectionDelegate {
    weak var delegate: AddNeedDelegate!
    
    var selectedImage: StockPhoto? {
        didSet {
            addNeedView.imageView.image = selectedImage?.image
            addNeedView.selectedPhoto = selectedImage?.cellModel.stockPhotoName
        }
    }
    
    var category: AlertCategory
    lazy var addNeedView = AddNeedToCategoryViewControllerView(category: category, photoPresentationTarget: self, photoPresentationSelector: #selector(presentPhotos), addNeedDelegate: delegate)
    
    init(category: AlertCategory, delegate: AddNeedDelegate) {
        self.category = category
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    override func loadView() {
        super.loadView()
        view = addNeedView
    }
    
    @objc private func presentPhotos() {
        let vc = StockPhotoViewController()
        vc.photoSelectionDelegate = self
        showDetailViewController(vc, sender: nil)
    }
    
}
