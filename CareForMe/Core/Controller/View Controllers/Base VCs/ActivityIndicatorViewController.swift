//
//  ActivityIndicatorViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 9/17/21.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {
    var indicator = UIActivityIndicatorView(style: .large)

    override func loadView() {
        super.loadView()
        view = UIView()

        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        view.addSubview(indicator)

        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension UIViewController {
    func createActivityView(backgroundColor: UIColor = .clear) -> ActivityIndicatorViewController {
        let child = ActivityIndicatorViewController()
        child.view.backgroundColor = backgroundColor
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        return child
    }
    
    func removeActivityView(child: ActivityIndicatorViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
