//
//  AddCategoryViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/10/21.
//

import UIKit

protocol CategoryUpdatable: AnyObject {
    func updateCategory(title: String?)
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
    
    func updateCategory(title: String?) {
        // call modelController and update view
        guard let title = title,
              !title.isEmpty,
              let color = categorySetupView.backgroundColor else {
            presentAlert(title: "Title Needed", message: "Please enter a title for your new category")
            return
        }
        
        categorySetupView.alertCategory.title = title
        categorySetupView.alertCategory.color = .init(uiColor: color)
//        controller.addCategory(category)
//        print(controller.categories.count)
        
        let vc = AddNeedToCategoryViewController(category: categorySetupView.alertCategory, delegate: self)
        present(vc, animated: true)
    }
}

extension AddCategoryViewController: ColorPickerDelegate {
    func colorWasPicked(_ color: UIColor) {
        categorySetupView.updateColors(basedOn: color)
    }
}

extension AddCategoryViewController: AddNeedDelegate {
    func receivedNeed(_ need: CareAlertType) {
        let alertCategory = categorySetupView.alertCategory
        alertCategory.alerts.append(need)
        categorySetupView.alertCategory = alertCategory
    }
}
