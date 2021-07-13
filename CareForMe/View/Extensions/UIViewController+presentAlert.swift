//
//  UIViewController+presentAlert.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/12/21.
//

import UIKit

extension UIViewController {
    
    /// Show an alert with a title, message, and OK button
    /// - Parameters:
    ///   - title: The Alert's Title
    ///   - message: The Alert's Message
    ///   - completion: Triggered when the alert is presented, open a closure to use
    func presentAlert(title: String, message: String, completion: @escaping (UIAlertAction) -> Void = {_ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    
    /// Show an alert with a title, message, yes button, and no button
    /// - Parameters:
    ///   - title: The Alert's Title
    ///   - message: The Alert's Message
    ///   - complete: Returns a bool (false if no was pressed, true if yes)
    func presentAlertwithYesNoPrompt(title: String, message: String, complete: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            complete(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            complete(false)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

