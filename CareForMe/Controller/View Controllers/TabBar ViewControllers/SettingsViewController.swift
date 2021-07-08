//
//  SettingsViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/7/21.
//

import UIKit

class SettingsViewController: UIViewController {
    var toggles: [LabeledToggleSwitch] = []

    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: toggles)
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
        
    init(toggles: LabeledToggleSwitch...) {
        self.toggles = toggles
        super.init(nibName: nil, bundle: nil)
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
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
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
        
        let toggle = LabeledToggleSwitch(title: "Notifications", toggleFunction: #selector(toggleNotifications), target: self)
        setNotificationSwitchState(for: toggle)
        addToggle(toggle: toggle)
        
        subviews()
    }
    
    private func setNotificationSwitchState(for toggle: LabeledToggleSwitch) {
        FirebaseMessagingController.shared.getNotificationSettings { permissionStatus in
            switch permissionStatus {
            case .authorized:
                toggle.setSwitchState(on: true)
            case .denied, .needPermission:
                toggle.setSwitchState(on: false)
            }
        }
    }
    
    @objc private func toggleNotifications(_ sender: UISwitch) {
        if !sender.isOn {
            AppSettingsController.disableNotifications()
        }
    }
    
    func addToggle(toggle: LabeledToggleSwitch) {
        stack.addArrangedSubview(toggle)
    }
}
