//
//  ParchmentPageViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/10/21.
//

import UIKit
import Parchment

struct ParchmentCellTest: PagingItem, Hashable, Comparable {
    
    var identifier: Int
    
    static func < (lhs: ParchmentCellTest, rhs: ParchmentCellTest) -> Bool {
        lhs.identifier < rhs.identifier
    }
    
}

class OnboardingViewController: InstructionViewController {
    
    let indicatorTitle: String
    let id: Int
    
    init(id: Int, indicatorText: String, title: String, instructions: String, image: Gif?, caption: String? = nil, buttonTitle: String, selectionDelegate: TargetSelector) {
        
        self.indicatorTitle = indicatorText
        self.id = id
        super.init(title: title, instructions: instructions, image: image, buttonTitle: buttonTitle, selectionDelegate: selectionDelegate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic ViewController")
    }
}

class OnboardingPagedViewController: PagingViewController {
    var titles: [String] = [
        "Welcome",
        "Account",
        "Link"
    ]
    
    lazy var onboardingWelcomeVC: OnboardingViewController = OnboardingViewController(id: 0, indicatorText: "Welcome", title: "Welcome To Care For Me", instructions: "Our goal is to safely and convenienently link you with your companion so you can plan, organize, and connect all in one place. To do that, you'll set up a secure account, and give your companion a unique join code that only you have", image: nil, buttonTitle: "Next: Your Account", selectionDelegate: TargetSelector(target: self, selector: #selector(activateViewController(_:))))
    
    lazy var onboardingAccountVC: OnboardingViewController = OnboardingViewController(id: 1, indicatorText: "Account", title: "Welcome To Account Setup", instructions: "Setting up your account is easy and allows for you to securely communicate with your companion", image: nil, buttonTitle: "Next: Link Companion", selectionDelegate: TargetSelector(target: self, selector: #selector(activateViewController(_:))))
    
    lazy var onboardingCompanionVC: OnboardingViewController = OnboardingViewController(id: 2, indicatorText: "Link", title: "Link To Your Companion", instructions: "Linking to a companion is easy. Just provide them with this 6 digit code and ask them to download the app", image: nil, buttonTitle: "Let's Get Started!", selectionDelegate: TargetSelector(target: self, selector: #selector( activateViewController(_:))))
    
    lazy var viewControllers: [OnboardingViewController] = {
        onboardingWelcomeVC.instructionView.button.tag = 0
        onboardingAccountVC.instructionView.button.tag = 1
        onboardingCompanionVC.instructionView.button.tag = 2
        
        let linkButton: UIButton = .fullWidthButton(with: "I want to confirm a code instead", color: .named(.secondaryLink), targetAndSelector: TargetSelector(target: self, selector: #selector(displayCodeConfirmationViewController)))
        
        let codeLabel: UILabel = UILabel()
        codeLabel.text = Int.randomString()
        codeLabel.font = .boldSystemFont(ofSize: 36)
        codeLabel.textAlignment = .center
        
        onboardingCompanionVC.instructionView.addView(codeLabel)
        onboardingCompanionVC.instructionView.addView(linkButton)
        
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
    
    @objc private func displayCodeConfirmationViewController() {
        let vc = ConfirmPINViewController()
        showDetailViewController(vc, sender: nil)
    }
    
}

extension OnboardingPagedViewController: PagingViewControllerDataSource {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        viewControllers.count
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        PagingIndexItem(index: index, title: titles[index])
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
