//
//  AddNeedToCategoryViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/11/21.
//

import UIKit

class AddNeedToCategoryViewController: UIViewController {
    var category: AlertCategory
    lazy var addNeedView = AddNeedToCategoryViewControllerView(alertCategory: category)
    
    init(category: AlertCategory) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    override func loadView() {
        super.loadView()
        view = addNeedView
    }
}
