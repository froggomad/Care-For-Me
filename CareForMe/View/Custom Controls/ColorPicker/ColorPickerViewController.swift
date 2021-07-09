//
//  ColorPickerViewController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/8/21.
//

import UIKit

protocol ColorPickerDelegate: AnyObject {
    func colorWasPicked(_ color: UIColor)
}

class ColorPickerViewController: UIViewController {
    weak var delegate: ColorPickerDelegate?
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [informationLabel, colorPicker, button])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .title3, weight: .semibold)
        label.backgroundColor = .systemBackground
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Please choose a color by tapping and dragging the color wheel below."
        return label
    }()
    
    lazy var colorPicker: ColorPicker = {
        let picker = ColorPicker()
        return picker
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set Color", for: .normal)
        button.addTarget(self, action: #selector(setColor), for: .touchUpInside)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.frame.size.height = 50
        return button
    }()
    
    init(color: UIColor = .black) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        colorPicker.addTarget(self, action: #selector(changeColor(_:)), for: .valueChanged)
        defer { colorPicker.color = color }
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subviews()
    }
    
    private func subviews() {
        view.addSubview(stackView)
        constraints()
    }
    
    private func constraints() {
        let padding:CGFloat = 20
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding)
        ])
    }
    
    @objc func changeColor(_ sender: ColorPicker) {
        view.backgroundColor = sender.color
    }
    
    @objc func setColor(_ sender: UIButton) {
        delegate?.colorWasPicked(colorPicker.color)
        dismiss(animated: true)
    }
    
}
