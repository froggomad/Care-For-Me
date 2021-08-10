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

class OnboardingPagedViewController: PagingViewController {
    var titles: [String] = [
        "Welcome",
        "Account",
        "Link"
    ]
    
    lazy var instruction1: InstructionViewController = InstructionViewController(title: "Welcome To Care For Me", instructions: "Our goal is to safely and convenienently link you with your companion so you can plan, organize, and connect all in one place", image: nil, buttonTitle: "Next: Your Account", selectionDelegate: TargetSelector(target: self, selector: #selector(activateViewController(_:))))
    
    lazy var instruction2: InstructionViewController = InstructionViewController(title: "Welcome To Account Setup", instructions: "Setting up your account is easy and allows for you to securely communicate with your companion", image: nil, buttonTitle: "Next: Link Companion", selectionDelegate: TargetSelector(target: self, selector: #selector(activateViewController(_:))))
    
    lazy var instruction3: InstructionViewController = InstructionViewController(title: "Link To Your Companion", instructions: "Linking to a companion is easy. Just provide them with this 6 digit code and ask them to download the app", image: nil, buttonTitle: "Let's Get Started!", selectionDelegate: TargetSelector(target: self, selector: #selector( activateViewController(_:))))
    
    lazy var viewControllers: [UIViewController] = {
        instruction1.instructionView.button.tag = 0
        instruction2.instructionView.button.tag = 1
        instruction3.instructionView.button.tag = 2
        
        return [
            instruction1,
            instruction2,
            instruction3
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
