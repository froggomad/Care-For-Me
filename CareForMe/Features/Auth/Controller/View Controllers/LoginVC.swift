//
//  LoginVC.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/5/21.
//

import UIKit

protocol LoginProcessable: AnyObject {
    func processLogin(email: String, password: String)
}

class LoginViewController: UIViewController, AuthControllable {
    
    var activityViewController: ActivityIndicatorViewController?
    
    private let authService = AuthService.shared
    lazy var authDelegate = AuthDelegate(self)
    
    lazy var loginView: AuthView =  AuthView(delegate: authDelegate)
    
    override func loadView() {
        self.view = loginView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    private func presentTabBar() {
        let tabBarController = TabBar.createMainTabBar()
        tabBarController.modalTransitionStyle = .flipHorizontal
        self.present(tabBarController, animated: true)
    }
    
}

extension LoginViewController: LoginProcessable {
    
    func processLogin(email: String, password: String) {
        
        activityViewController = createActivityView()
        
        guard let emailAddress = loginView.emailAddress,
              let password = loginView.password else {
            removeActivityView(child: activityViewController!)
            return
        }
        authService.loginWithEmail(emailAddress, password: password) { [weak self] result in
            guard let self = self else { return }
            self.removeActivityView(child: self.activityViewController!)
            switch result {
            case .success:
                self.presentTabBar()
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
