//
//  SettingsViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/7/21.
//

import UIKit

class SettingsViewController: ParentDetailViewController, AuthenticableViewController {
    
    lazy var stack: UIStackView = {
        let stack: UIStackView = .componentStack(elements: [notificationToggle, savePasswordsToggle, tableView], spacing: 20)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var notificationToggle: LabeledToggleSwitch = {
        LabeledToggleSwitch(title: "Notifications", toggleFunction: #selector(toggleNotifications), target: self)
    }()
    
    lazy var savePasswordsToggle: LabeledToggleSwitch = {
        LabeledToggleSwitch(title: "Save Passwords", toggleFunction: #selector(toggleSavePasswords), target: self)
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsTableViewCell")
        tv.dataSource = self
        tv.delegate = self
        tv.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return tv
    }()
    
    lazy var signOutButton: UIButton = {
        let targetSelector = TargetSelector(target: self, selector: #selector(signOut))
        return .standardCFMButton(with: "Sign Out", targetAndSelector: targetSelector)
    }()
    
    init(toggles: LabeledToggleSwitch...) {        
        
        super.init(nibName: nil, bundle: nil)
        for toggle in toggles {
            addToggle(toggle: toggle)
        }
        setTab()
        NotificationCenter.default.addObserver(forName: .joinRequestChanged, object: nil, queue: .main) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("this is a programmatic view")
    }
    
    private func subviews() {
        view.addSubview(stack)
        view.addSubview(signOutButton)
        constraints()
    }
    
    private func constraints() {
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            stack.bottomAnchor.constraint(equalTo: signOutButton.safeAreaLayoutGuide.topAnchor, constant: -padding),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            
            signOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            signOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    private func setTab() {
        title = "Settings"
        tabBarItem.image = UIImage(systemName: "gearshape")
        tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
    }
    
    @objc private func signOut() {
        AuthService.shared.signOut()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        subviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authenticate()
        setNotificationSwitchState()
        setSavePasswordsSwitchState()
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
    
    private func setSavePasswordsSwitchState() {
        guard let userDefaultsSetting = UserDefaultsConfig.savePasswords[AuthService.shared.user?.privateDetails.userId ?? ""] else { return }
    
        savePasswordsToggle.setSwitchState(on: userDefaultsSetting ?? false)
    }
    
    @objc private func toggleNotifications(_ sender: UISwitch) {
        
        if !sender.isOn {
            let vc = InstructionViewController(title: "About Disabling Notifications",
                                               instructions: "In order to disable notifications, it's necessary to visit the settings app",
                                               image: .notificationsOff,
                                               caption: "To open your iOS Settings App, tap below",
                                               buttonTitle: "Open Settings",
                                               selectionDelegate: TargetSelector(target: self, selector: #selector(openSettings)))
            showDetailViewController(vc, sender: nil)
        } else {
            FirebaseMessagingController.shared.registerForRemoteNotifications()
            
            let vc = InstructionViewController(title: "About Setting Notifications",
                                               instructions: "In order to enable notifications for the app, it's necessary to visit your settings app and enable notifications manually.",
                                               image: .notificationsOn,
                                               caption: "To open your iOS Settings App, tap below",
                                               buttonTitle: "Open Settings",
                                               selectionDelegate: TargetSelector(target: self, selector: #selector(openSettings)))
            showDetailViewController(vc, sender: nil)
        }
    }
    
    @objc private func toggleSavePasswords(_ sender: UISwitch) {
        print()
        UserDefaultsConfig.savePasswords[AuthService.shared.user?.privateDetails.userId ?? ""] = sender.isOn
    }
    
    func addToggle(toggle: LabeledToggleSwitch) {
        stack.addArrangedSubview(toggle)
    }
    
    @objc private func openSettings() {
        AppSettingsController.openSettings()
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            guard let user = AuthService.shared.user else { return 0 }
            return user.privateDetails.joinRequests?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell") else {
            fatalError("bad cell mojo")
        }
        cell.accessoryType = .disclosureIndicator
        if indexPath.section == 0 {
            cell.textLabel?.text = "Link With a Companion"
        } else if indexPath.section == 1 {
            guard let user = AuthService.shared.user else { return cell }
            cell.textLabel?.text = user.privateDetails.joinRequests?[indexPath.row].username
        }
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = SettingsLinkVC()
            vc.modalPresentationStyle = .fullScreen
            showDetailViewController(vc, sender: nil)
        } else if indexPath.section == 1 {
            guard let joinRequest = AuthService.shared.user?.privateDetails.joinRequests?[indexPath.row]
            else { return }
            
            let vc = LinkRequestViewController(request: joinRequest)
            showDetailViewController(vc, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let user = AuthService.shared.user else { return nil }
        if section == 0 {
            return "Actions"
        }
        if section == 1 && user.privateDetails.joinRequests != nil && !user.privateDetails.joinRequests!.isEmpty {
            return "Join Requests"
        }
        return nil
    }
}

enum Gif: String {
    case notificationsOff
    case notificationsOn
}
