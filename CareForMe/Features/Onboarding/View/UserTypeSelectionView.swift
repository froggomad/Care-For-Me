//
//  UserTypeSelectionView.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/10/21.
//

import UIKit

class UserTypeSelectionView: UIView {
    weak var pickerDataSource: UIPickerViewDataSource?
    weak var pickerDelegate: UIPickerViewDelegate?
    
    lazy var stack: UIStackView = {
        let stack: UIStackView = .componentStack(elements: [infoLabel, selectionView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 0
        return stack
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel.headlineLabel(text: "I'm a ...")
        label.textAlignment = .center
        return label
    }()
    
    lazy var selectionView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = pickerDataSource
        picker.delegate = pickerDelegate
        picker.heightAnchor.constraint(equalToConstant: 150).isActive = true
        return picker
    }()
    
    required init(pickerDataSource: UIPickerViewDataSource, pickerDelegate: UIPickerViewDelegate) {
        super.init(frame: .zero)
        self.pickerDataSource = pickerDataSource
        self.pickerDelegate = pickerDelegate
        subviews()
    }
    
    private func subviews() {
        backgroundColor = .systemBackground
        addSubview(stack)
        constraints()
    }
    
    private func constraints() {
        let spacing: CGFloat = 20
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: spacing),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -spacing),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: spacing)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
}
