//
//  LinkRequestViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/21/21.
//

import UIKit

class LinkRequestViewController: UIViewController {
    let request: JoinRequest
    
    required init(request: JoinRequest) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView.componentStack(elements: [titleLabel, buttonStack], spacing: 40)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var buttonStack: UIStackView = {
        let stack = UIStackView.componentStack(elements: [acceptButton, denyButton], spacing: 16)
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.title3Label(text: "\(request.username) would like to securely link their account with yours")
        label.numberOfLines = 0
        return label
    }()
    
    lazy var acceptButton: UIButton = {
        let targetSelector = TargetSelector(target: self, selector: #selector(acceptRequest))
        let button = UIButton.standardCFMButton(with: "Accept", color: .systemGreen, targetAndSelector: targetSelector)
        return button
    }()
    
    lazy var denyButton: UIButton = {
        let targetSelector = TargetSelector(target: self, selector: #selector(denyRequest))
        let button = UIButton.standardCFMButton(with: "Deny", color: .systemRed, targetAndSelector: targetSelector)
        return button
    }()
    
    @objc private func acceptRequest() {
        guard let user = AuthService.shared.user else { return }
        UserLinkController.acceptJoinRequest(userId: user.privateDetails.userId, joinCode: request.code, userType: user.publicDetails.userType) { [weak self] result in
            switch result {
            case .success(let response):
                print(response)
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error)
                self?.presentAlert(title: "Error accepting request", message: "We have been notified. Please try again. If the error persists, please try generating a new join code in your settings")
            }
        }
    }
    
    @objc private func denyRequest() {
        guard let user = AuthService.shared.user else { return }
        UserLinkController.denyJoinRequest(userId: user.privateDetails.userId, joinCode: request.code) { [weak self] cloudResult in
            guard let self = self else { return }
            switch cloudResult {
            case .success(let result):
                if result {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.presentAlertWithYesNoPrompt(title: "Retry?", message: "There was an error denying the request. Try again?") { result in
                        if result {
                            self.denyRequest()
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            case .failure(let error):
                print(error)
                self.presentAlertWithYesNoPrompt(title: "Retry?", message: "There was an error denying the request. Try again?") { result in
                    if result {
                        self.denyRequest()
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        modalPresentationStyle = .fullScreen
        constraints()
    }
    
    private func constraints() {
        let spacing: CGFloat = 40
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacing),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing)
        ])
    }
}
