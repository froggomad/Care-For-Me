//
//  ColorPicker.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/8/21.
//

import UIKit

class ColorPicker: UIControl {

    //MARK: Properties
    var color: UIColor = .white {
        didSet {
            sendActions(for: .valueChanged)
            brightnessLabel.setContextualTextColor(for: color)
        }
    }
    
    var colorWheel = ColorWheel()
    
    lazy var opacityStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [brightnessSlider, brightnessLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var brightnessSlider = UISlider()
    
    lazy var brightnessLabel: UILabel = {
        let label = UILabel()
        label.text = "Brightness"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubViews()
    }
    
    private func setupSubViews() {
        backgroundColor = .clear
        
        //Color Wheel
        colorWheel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(colorWheel)
        NSLayoutConstraint.activate([
            colorWheel.topAnchor.constraint(equalTo: topAnchor),
            colorWheel.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorWheel.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorWheel.heightAnchor.constraint(equalTo: colorWheel.widthAnchor)
        ])
        
        //brightness slider
        brightnessSlider.minimumValue = 0
        brightnessSlider.maximumValue = 1
        brightnessSlider.value = 0.8
        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        
        brightnessSlider.addTarget(self, action: #selector(changeBrightness), for: .touchUpInside)
        addSubview(opacityStack)
        NSLayoutConstraint.activate([
            opacityStack.topAnchor.constraint(equalTo: colorWheel.bottomAnchor, constant: 8),
            opacityStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            opacityStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc func changeBrightness() {
        colorWheel.brightness = CGFloat(brightnessSlider.value)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        color = colorWheel.color(for: touchPoint)
        sendActions(for: [.touchDown, .valueChanged])
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint) {
            color = colorWheel.color(for: touchPoint)
            sendActions(for: [.touchDragInside, .valueChanged])
        } else {
            sendActions(for: [.touchDragOutside])
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let touch = touch else { return }
        
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint) {
            color = colorWheel.color(for: touchPoint)
            sendActions(for: [.touchUpInside, .valueChanged])
        } else {
            sendActions(for: [.touchUpOutside])
        }
        
        super.endTracking(touch, with: event)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        sendActions(for: .touchCancel)
    }
    
}

