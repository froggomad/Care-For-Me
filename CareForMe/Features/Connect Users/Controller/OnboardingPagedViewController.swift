//
//  OnboardingPagedViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/11/21.
//

import UIKit
import Parchment

class OnboardingPagedViewController: PagingViewController {
    
    lazy var onboardingWelcomeVC: OnboardingViewController = OnboardingViewController(id: 0, indicatorText: "Welcome", title: "Welcome To Care For Me", instructions: "Our goal is to safely and convenienently link you with your companion so you can plan, organize, and connect all in one place. To do that, you'll set up a secure account, and give your companion a unique join code that only you have", image: nil, buttonTitle: "Next: Your Account", selectionDelegate: TargetSelector(target: self, selector: #selector(activateViewController(_:))), additionalViews: [])
    
    lazy var onboardingAccountVC: OnboardingViewController = OnboardingViewController(id: 1, indicatorText: "Account", title: "Welcome To Account Setup", instructions: "Setting up your account is easy and allows for you to securely communicate with your companion", image: nil, buttonTitle: "Next: Link Companion", selectionDelegate: TargetSelector(target: self, selector: #selector(activateViewController(_:))), additionalViews: [])
    
    lazy var onboardingCompanionVC: OnboardingLinkVC = OnboardingLinkVC(selectionDelegate: TargetSelector(target: self, selector: #selector(activateViewController(_:))))
    
    lazy var viewControllers: [OnboardingViewController] = {
        return [
            onboardingWelcomeVC,
            onboardingAccountVC,
            onboardingCompanionVC
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        select(index: 0)
        indicatorColor = .named(.link)
        self.navigationController?.navigationBar.isTranslucent = false
        borderOptions = .visible(height: 1, zIndex: 1, insets: .zero)
        borderColor = .black
        menuPosition = .bottom
        
        view.backgroundColor = .white
    }
    
}

extension OnboardingPagedViewController: PagingViewControllerDataSource {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        viewControllers.count
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        PagingIndexItem(index: index, title: viewControllers[index].indicatorTitle)
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        viewControllers[index]
    }
    
    @objc func activateViewController(_ sender: UIButton) {
        let index = sender.tag
        guard index < viewControllers.count - 1 else {
            if index == viewControllers.count - 1 { navigationController?.popViewController(animated: true) }
            return
        }
        select(index: index + 1)
    }
    
}
