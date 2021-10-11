//
//  OnboardingPagedViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/11/21.
//

import UIKit
import Parchment

class OnboardingPagedViewController: UIViewController {
    
    var userType: UserType = .client
    
    lazy var onboardingWelcomeVC: OnboardingViewController =
        OnboardingViewController(id: 0,
                                 indicatorText: "Welcome",
                                 title: "Welcome To Care For Me",
                                 instructions: "Care For Me is designed to help caregivers and those they care for.\n\nIf you're a caregiver, we'll help you keep your companion's needs organized and link you securely to your companion so they can alert you when they have needs you can meet.\n\nIf you're a companion, we'll help you by making it really easy to tell your caregiver what you need, when you need it. Once your needs are set up by you or your caregiver, you just tap a button, and they'll know you need help!",
                                 image: nil,
                                 buttonTitle: "Next: Learn About Accounts",
                                 selectionDelegate: TargetSelector(target: self, selector: #selector(activateViewController(_:))),
                                 additionalViews: [])
    
    lazy var selectionController: UserTypeSelectionController = {
        let controller = UserTypeSelectionController()
        controller.delegate = self
        return controller
    }()
    
    lazy var appUseViewController: OnboardingViewController =
        OnboardingViewController(id: 1,
                                 indicatorText: "App Use",
                                 title: "How Will You Use Care For Me?",
                                 instructions: "Are you a client needing assistance, or a caregiver providing assistance?",
                                 image: nil,
                                 buttonTitle: "Next: Account Creation",
                                 selectionDelegate: TargetSelector(target: self, selector: #selector(activateViewController(_:))),
                                 additionalViews: [selectionController.userTypePickerView])
    
    lazy var onboardingLinkInfoVC: OnboardingViewController =
        OnboardingViewController(id: 2,
                                 indicatorText: "Account",
                                 title: "Secure Account Creation",
                                 instructions: "Our goal is to safely and convenienently link you with your companion so you can plan, organize, and connect all in one place. To do that, you'll set up a secure account, and give your companion a unique join code that only you have",
                                 image: nil,
                                 buttonTitle: "Register Account",
                                 selectionDelegate: TargetSelector(target: self, selector: #selector(register)),
                                 additionalViews: [])
    
    lazy var onboardingCompanionVC: OnboardingLinkVC = OnboardingLinkVC(id: 3)
    
    lazy var viewControllers: [OnboardingViewController] = {
        return [
            onboardingWelcomeVC,
            appUseViewController,
            onboardingLinkInfoVC
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
        let vc = RegistrationViewController(userType: userType) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.perform(#selector(self.presentLink), with: nil, afterDelay: 0)
            }
        }
        
        present(vc, animated: true)
    }
    
    @objc private func presentLink() {
        self.onboardingCompanionVC.modalPresentationStyle = .fullScreen
        self.present(self.onboardingCompanionVC, animated: true)
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
            if index == viewControllers.count - 1 {
                let tab = TabBar.createMainTabBar()
                present(tab, animated: true)
            }
            return
        }
        pagingVC.select(index: index + 1)
    }
    
}

extension OnboardingPagedViewController: UserTypeSelectionDelegate {
    func typeSelected(_ userType: UserType) {
        self.userType = userType
    }
}
