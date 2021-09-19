//
//  OnboardingPagedViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/11/21.
//

import UIKit
import Parchment

class OnboardingPagedViewController: UIViewController {
    
    lazy var onboardingWelcomeVC: OnboardingViewController =
        OnboardingViewController(id: 0,
                                 indicatorText: "Welcome",
                                 title: "Welcome To Care For Me",
                                 instructions: "Care For Me is designed to help caregivers and those they care for.\n\nIf you're a caregiver, we'll help you keep your companion's needs organized and link you securely to your companion so they can alert you when they have needs you can meet.\n\nIf you're a companion, we'll help you by making it really easy to tell your caregiver what you need, when you need it. Once your needs are set up by you or your caregiver, you just tap a button, and they'll know you need help!",
                                 image: nil,
                                 buttonTitle: "Next: Learn About Accounts",
                                 selectionDelegate: TargetSelector(target: self, selector: #selector(activateViewController(_:))),
                                 additionalViews: [])
    
    lazy var onboardingLinkInfoVC: OnboardingViewController =
        OnboardingViewController(id: 1,
                                 indicatorText: "Account",
                                 title: "Secure Account Creation",
                                 instructions: "Our goal is to safely and convenienently link you with your companion so you can plan, organize, and connect all in one place. To do that, you'll set up a secure account, and give your companion a unique join code that only you have",
                                 image: nil,
                                 buttonTitle: "Register Account",
                                 selectionDelegate: TargetSelector(target: self, selector: #selector(register)),
                                 additionalViews: [])
    
    lazy var onboardingCompanionVC: OnboardingLinkVC =
        OnboardingLinkVC(id: 2, selectionDelegate: TargetSelector(target: self, selector: #selector(activateViewController(_:))))
    
    lazy var viewControllers: [OnboardingViewController] = {
        return [
            onboardingWelcomeVC,
            onboardingLinkInfoVC,
            onboardingCompanionVC
        ]
    }()
    
    lazy var pagingVC: PagingViewController = {
        let vc = PagingViewController()
        vc.dataSource = self
        vc.indicatorColor = .named(.link)
        vc.borderOptions = .visible(height: 1, zIndex: 1, insets: .zero)
        vc.borderColor = .black
        vc.menuInteraction = .none
        vc.collectionView.isUserInteractionEnabled = false
        return vc
    }()
    
    @objc private func register() {
        let vc = RegistrationViewController()
        present(vc, animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        addChild(pagingVC)
        view.addSubview(pagingVC.view)
        pagingVC.didMove(toParent: self)
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // library isn't accounting for safe area
            pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
        pagingVC.select(index: index + 1)
    }
    
}
