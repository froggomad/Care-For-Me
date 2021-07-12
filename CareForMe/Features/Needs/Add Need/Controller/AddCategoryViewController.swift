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

class AddCategoryViewController: UIViewController, CategoryUpdatable {
    
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
        present(vc, animated: true)
    }
    
    func createCategory(title: String?) {
        // call modelController and update view
        guard let title = title,
              !title.isEmpty else {
            // TODO: present alert
            return
        }
        
        let category = AlertCategory(id: UUID(), color: "red", type: title)
        
//        controller.addCategory(category)
        print(controller.categories.count)
        
        let vc = AddNeedToCategoryViewController(category: category)
        present(vc, animated: true)
    }
}

extension AddCategoryViewController: ColorPickerDelegate {
    func colorWasPicked(_ color: UIColor) {
        categorySetupView.updateColors(basedOn: color)
    }
}
