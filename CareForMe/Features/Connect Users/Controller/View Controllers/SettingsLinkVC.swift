//
//  SettingsLinkVC.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/23/21.
//

import UIKit

final class SettingsLinkVC: OnboardingLinkVC {
    
    init(id: Int = 0, additionalViews: [UIView] = [], continueButtonTitle: String = "Continue", instructionText: String = "Linking to a companion is easy. Just provide them with this 6 digit code and ask them to download the app.") {
        super.init(id: id, additionalViews: additionalViews, continueButtonTitle: continueButtonTitle, instructions: instructionText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
}

extension OnboardingLinkVC: LinkProcessable {
    @objc func linkConnected() {
        guard presentingViewController as? MainTabController == nil else {
            dismiss(animated: true)
            return
        }
        let tab = TabBar.createMainTabBar()
        present(tab, animated: false)
    }
}
