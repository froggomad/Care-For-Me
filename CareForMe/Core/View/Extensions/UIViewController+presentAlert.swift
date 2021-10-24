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
    ///   - handler: Triggered when the alert is presented, open a closure to use
    func presentAlert(title: String, message: String, handler: @escaping (Bool) -> Void = { _ in }) {
        let alert = AlertViewController()
        alert.modalPresentationStyle = .overCurrentContext
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
            alert.present(title: title, message: message, handler: handler)
        }
    }
    
    
    /// Show an alert with a title, message, yes button, and no button
    /// - Parameters:
    ///   - title: The Alert's Title
    ///   - message: The Alert's Message
    ///   - complete: Returns a bool (false if no was pressed, true if yes)
    func presentAlertWithYesNoPrompt(title: String, message: String, handler: @escaping (Bool) -> Void) {
        let alert = AlertViewController(yesNoMode: true)
        alert.modalPresentationStyle = .overCurrentContext
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
            alert.present(title: title, message: message, handler: handler)
        }
    }
}

