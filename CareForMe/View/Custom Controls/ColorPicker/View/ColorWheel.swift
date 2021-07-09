//
//  ColorWheel.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/8/21.
//

import UIKit

class ColorWheel: UIView {
    
    //MARK: Properties
    var color: UIColor = .white
    var brightness: CGFloat = 0.8 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //MARK: View Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = false //the UIControl will be used for interaction instead
        clipsToBounds = true
        
        let radius = frame.width / 2
        layer.cornerRadius = radius
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
    }
    //use this with CoreGraphics/UIKit when custom drawing a view's contents
    override func draw(_ rect: CGRect) {
        let size: CGFloat = 1
        
        for y in stride(from: 0, through: bounds.maxY, by: size) {
            for x in stride(from: 0, through: bounds.maxX, by: size) {
                let color = self.color(for: CGPoint(x: x, y: y))
                let pixel = CGRect(x: x, y: y, width: size, height: size)
                
                color.set()
                UIRectFill(pixel)
            }
        }
    }
    
    func color(for location: CGPoint) -> UIColor {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let dy = location.y - center.y //delta y
        let dx = location.x - center.x //delta x
        let offset = CGPoint(x: dx/center.x, y: dy/center.y)
        let (hue, saturation) = Color.getHueSaturation(at: offset)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    
    

}
