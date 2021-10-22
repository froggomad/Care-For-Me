//
//  OnboardingLinkVC.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/11/21.
//

import UIKit

protocol LinkProcessable {
    func linkConnected()
}

class OnboardingLinkVC: OnboardingViewController {
    lazy var linkButton: UIButton = .standardCFMButton(with: "I want to confirm a code instead", color: .named(.secondaryLink), targetAndSelector: TargetSelector(target: self, selector: #selector(displayCodeConfirmationViewController)))
    
    lazy var codeLabel: UILabel = {
        let codeLabel = UILabel()
        codeLabel.text = Int.randomString()
        codeLabel.font = .boldSystemFont(ofSize: 36)
        codeLabel.textAlignment = .center
        return codeLabel
    }()
    
    @objc private func displayCodeConfirmationViewController() {
        let vc = ConfirmPINViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    init(id: Int, additionalViews: [UIView] = [], continueButtonTitle: String = "Let's Get Started!", instructions: String = "Linking to a companion is easy. Just provide them with this 6 digit code and ask them to download the app. You can find this code later in your settings.") {
        super.init(id: id, indicatorText: "Link", title: "Link To Your Companion", instructions: instructions, image: nil, buttonTitle: continueButtonTitle, additionalViews: additionalViews)
        setupInstructionView()
    }
    
    func setupInstructionView() {
        instructionView.button.addTarget(self, action: #selector(linkConnected), for: .touchUpInside)
        instructionView.addView(codeLabel)
        instructionView.addView(linkButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view controller")
    }
    
}

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
