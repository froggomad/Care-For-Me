//
//  AuthViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 9/16/21.
//

import UIKit

enum AuthType: String, CaseIterable {
    case login
    case registration
}

protocol AuthControllable: UIViewController {
    var authDelegate: AuthDelegate { get }
}

class AuthViewController: UIViewController {
    
    var authVC: AuthControllable! {
        didSet {
            isLogin = authVC as? LoginViewController != nil
        }
    }
    
    private func createAuthView(of type: AuthType) {
        var vc: AuthControllable

        switch type {
        case .login:
            vc = LoginViewController()
        case .registration:
            vc = RegistrationViewController()
        }
        
        self.authVC = vc
    }
    
    @objc private func changeAuthVC() {
        removeContainedVC()
        
        if isLogin {
            self.authVC = RegistrationViewController()
        } else {
            self.authVC = LoginViewController()
        }
        
        setAuthView()
    }
    
    fileprivate func removeContainedVC() {
        authVC.willMove(toParent: nil)
        authVC.view.removeFromSuperview()
        authVC.removeFromParent()
    }
    
    private func setAuthView() {
        addChild(authVC)
        containerView.addSubview(authVC.view)
        authVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            authVC.view.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            authVC.view.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor),
            authVC.view.topAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            authVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            authVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        ])
        
        authVC.didMove(toParent: self)
    }
    
    private lazy var isLogin: Bool = authVC as? LoginViewController != nil
    
    lazy var authTypeSegmentedControl: UISegmentedControl = {
        let items = AuthType.allCases.map { $0.rawValue.capitalized }
        let control = UISegmentedControl(items: items)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = isLogin ? 0 : 1
        control.addTarget(self, action: #selector(changeAuthVC), for: .valueChanged)
        return control
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    required init(authType: AuthType) {
        super.init(nibName: nil, bundle: nil)
        createAuthView(of: authType)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(authTypeSegmentedControl)
        view.addSubview(containerView)
        constraints()
        setAuthView()
    }
    
    private func constraints() {
        let spacing: CGFloat = 20
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing*3),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacing),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            
            authTypeSegmentedControl.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -spacing),
            authTypeSegmentedControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
    }
    
}
