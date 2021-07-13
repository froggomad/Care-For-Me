//
//  AddCategoryViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/10/21.
//

import UIKit

protocol CategoryUpdatable: AnyObject {
    func createCategory(title: String?)
}

class AddCategoryViewController: ParentDetailViewController, CategoryUpdatable {
    
    private let controller = NeedsController()
    
    lazy var categorySetupView: AddCategoryViewControllerView = {
        let view = AddCategoryViewControllerView(target: self, selector: #selector(presentColorChoice))
        view.categoryUpdateDelegate = self
        return view
    }()
    
    override func loadView() {
        view = categorySetupView
    }
    
    @objc func presentColorChoice() {
        let vc = ColorPickerViewController()
        vc.controllerDelegate = self
        showDetailViewController(vc, sender: nil)
    }
    
    func createCategory(title: String?) {
        // call modelController and update view
        guard let title = title,
              !title.isEmpty,
              let color = categorySetupView.backgroundColor else {
            presentAlert(title: "Title Needed", message: "Please enter a title for your new category")
            return
        }
        
        let category = AlertCategory(id: UUID(), color: .init(uiColor: color), type: title)
        
//        controller.addCategory(category)
//        print(controller.categories.count)
        
        let vc = AddNeedToCategoryViewController(category: category)
        showDetailViewController(vc, sender: nil)
    }
}

extension AddCategoryViewController: ColorPickerDelegate {
    func colorWasPicked(_ color: UIColor) {
        categorySetupView.updateColors(basedOn: color)
    }
}
