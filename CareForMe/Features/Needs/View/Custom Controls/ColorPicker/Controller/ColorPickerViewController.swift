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
        let view = ColorPickerView(buttonTarget: self,
                                   buttonAction: #selector(setColor(_:)),
                                   colorChangeTarget: self,
                                   colorChangeAction: #selector(changeColor(_:))
        )
        return view
    }()
    
    init(color: UIColor = .systemBackground) {
        defer { colorPickerView.color = color }
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
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
