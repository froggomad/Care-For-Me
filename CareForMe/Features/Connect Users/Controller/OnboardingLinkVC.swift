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

final class OnboardingLinkVC: OnboardingViewController {
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
        showDetailViewController(vc, sender: nil)
    }
    
    init(id: Int, additionalViews: [UIView] = []) {
        
        super.init(id: id, indicatorText: "Link", title: "Link To Your Companion", instructions: "Linking to a companion is easy. Just provide them with this 6 digit code and ask them to download the app. You can find this code later in your settings.", image: nil, buttonTitle: "Let's Get Started!", additionalViews: additionalViews)
        instructionView.button.addTarget(self, action: #selector(linkConnected), for: .touchUpInside)
        instructionView.addView(codeLabel)
        instructionView.addView(linkButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view controller")
    }
    
}

extension OnboardingLinkVC: LinkProcessable {
    @objc func linkConnected() {
        let tab = TabBar.createMainTabBar()
        present(tab, animated: false)
    }
}
