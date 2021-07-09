//
//  SettingsViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/7/21.
//

import UIKit

class SettingsViewController: ParentDetailViewController {

    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [notificationToggle])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var notificationToggle: LabeledToggleSwitch = {
        LabeledToggleSwitch(title: "Notifications", toggleFunction: #selector(toggleNotifications), target: self)
    }()
        
    init(toggles: LabeledToggleSwitch...) {        
        
        super.init(nibName: nil, bundle: nil)
        for toggle in toggles {
            addToggle(toggle: toggle)
        }
        setTab()
    }
    
    required init?(coder: NSCoder) {
        fatalError("this is a programmatic view")
    }
    
    private func subviews() {
        view.addSubview(stack)
        constraints()
    }
    
    private func constraints() {
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
        ])
    }
    
    private func setTab() {
        self.title = "Settings"
        self.tabBarItem.image = UIImage(systemName: "gearshape")
        self.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        subviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNotificationSwitchState()
    }
    
    private func setNotificationSwitchState() {
        FirebaseMessagingController.shared.getNotificationSettings { [weak self] permissionStatus in
            switch permissionStatus {
            case .authorized:
                self?.notificationToggle.setSwitchState(on: true)
            case .denied, .needPermission:
                self?.notificationToggle.setSwitchState(on: false)
            }
        }
    }
    
    @objc private func toggleNotifications(_ sender: UISwitch) {
        
        if !sender.isOn {
            let vc = InstructionViewController(title: "Notifications have been disabled for this session only",
                                               instructions: "In order to disable notifications for the app, it's necessary to visit your settings app and disable notifications manually.",
                                               image: Gif.notificationsOff.rawValue,
                                               caption: "To open your iOS Settings App, tap below",
                                               buttonTitle: "Open Settings")
            showDetailViewController(vc, sender: nil)
        } else {
            FirebaseMessagingController.shared.registerForRemoteNotifications()
            
            let vc = InstructionViewController(title: "About Setting Notifications",
                                               instructions: "In order to enable notifications for the app, it's necessary to visit your settings app and enable notifications manually.",
                                               image: Gif.notificationsOn.rawValue,
                                               caption: "To open your iOS Settings App, tap below",
                                               buttonTitle: "Open Settings")
            showDetailViewController(vc, sender: nil)
        }
    }
    
    func addToggle(toggle: LabeledToggleSwitch) {
        stack.addArrangedSubview(toggle)
    }
    
}

enum Gif: String {
    case notificationsOff
    case notificationsOn
}
