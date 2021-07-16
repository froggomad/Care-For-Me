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
    
    private let controller = NeedsController.shared
    
    
    
    lazy var categorySetupView: AddCategoryViewControllerView = {
        let view = AddCategoryViewControllerView(addNeedPresentationTargetSelector: (self, #selector(presentNeed)), colorButtonTargetSelector: (self, #selector(presentColorChoice)), delegate: self)
        return view
    }()
    
    override func loadView() {
        view = categorySetupView
    }
    
    @objc func presentColorChoice() {
        let vc = ColorPickerViewController(color: categorySetupView.alertCategory.color.uiColor, delegate: self)
        showDetailViewController(vc, sender: nil)
    }
    
    func updateCategory(title: String?) {
        // call modelController and update view
        guard let title = title,
              !title.isEmpty
        else {
            presentAlert(title: "Title Needed", message: "Please enter a title for your new category") { [weak self] _ in
                self?.categorySetupView.titleTextField.becomeFirstResponder()
            }
            return
        }
        let category = categorySetupView.alertCategory
        category.title = title
        categorySetupView.alertCategory = category
        
        controller.editCategory(category, title: title) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                print(error)
            }
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func presentNeed() {
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
    func receivedNeed(_ need: CareTypeable) {
        let alertCategory = categorySetupView.alertCategory
        alertCategory.alerts.append(need)
        categorySetupView.alertCategory = alertCategory
        
        guard alertCategory.alerts.count > 0 else {
            categorySetupView.needLabel.text = "Needs"
            return
        }
        categorySetupView.needLabel.text = "Needs: \(alertCategory.alerts.count)"
    }
}
