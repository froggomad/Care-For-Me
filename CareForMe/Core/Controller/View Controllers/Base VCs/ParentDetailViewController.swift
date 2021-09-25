//
//  ParentDetailViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/8/21.
//

import UIKit

protocol DetailPresentable: UIViewController {
    func showDetailViewController(_ vc: UIViewController, sender: Any?)
}

class ParentDetailViewController: UIViewController, DetailPresentable {
    
    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        if let navVC = navigationController {
            navVC.pushViewController(vc, animated: true)
        } else {
            present(vc, animated: true)
        }
    }
    
}
