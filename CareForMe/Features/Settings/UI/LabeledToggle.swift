//
//  LabeledToggle.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/7/21.
//

import UIKit

class LabeledToggleSwitch: UIView {
    var title: String
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, toggleSwitch])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.alignment = .top
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label  = UILabel()
        label.text = title
        label.font = .preferredFont(for: .body, weight: .bold)
        return label
    }()
    
    lazy var toggleSwitch: UISwitch = {
        var toggleSwitch = UISwitch()
        return toggleSwitch
    }()
    
    init(title: String, toggleFunction selector: Selector, target: Any, event: UIControl.Event = .valueChanged) {
        self.title = title
        super.init(frame: .zero)
        toggleSwitch.addTarget(target, action: selector, for: event)
        subviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Programmatic View")
    }
    
    private func subviews() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    func setSwitchState(on: Bool) {
        toggleSwitch.isOn = on
    }

}
