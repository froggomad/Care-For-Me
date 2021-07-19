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
    weak var controllerDelegate: ColorPickerDelegate?
    
    lazy var colorPickerView: ColorPickerView = {
        let buttonTargetSelector = TargetSelector(target: self, selector: #selector(setColor(_:)))
        let colorTargetSelector = TargetSelector(target: self, selector: #selector(changeColor(_:)))
        let view = ColorPickerView(buttonTargetSelector: buttonTargetSelector, colorTargetSelector: colorTargetSelector)
        return view
    }()
    
    init(color: UIColor = .systemBackground) {
        defer { colorPickerView.color = color }
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    init(color: UIColor = .systemBackground, delegate: ColorPickerDelegate) {
        defer { colorPickerView.color = color }
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        self.controllerDelegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("programmatic view")
    }
    
    override func loadView() {
        view = colorPickerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func changeColor(_ sender: ColorPicker) {
        view.backgroundColor = sender.color
    }
    
    @objc func setColor(_ sender: UIButton) {
        let backgroundColor = view.backgroundColor ?? .black
        controllerDelegate?.colorWasPicked(backgroundColor)
        if let navC = navigationController {
            navC.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
}
