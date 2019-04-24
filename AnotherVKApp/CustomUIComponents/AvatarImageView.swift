//
//  AvatarImageView.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 03/03/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit
@IBDesignable class AvatarImageView: UIImageView {
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    //Вычисляемая переменная для удобной работы со слоем
    @IBInspectable var shapeLayer: CAShapeLayer {
        return self.layer as! CAShapeLayer
    }
    @IBInspectable  var cornerRadius: CGFloat = 16 {
        didSet {
            self.updateCornerRadius()
        }
    }
    @IBInspectable var shadowColor = UIColor.black.cgColor {
        didSet {
            self.updateShadowColor()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateShadowOpacity()
        }
    }
    @IBInspectable  var shadowRadius: CGFloat = 8 {
        didSet {
            self.updateShadowRadius()
        }
    }
    @IBInspectable var shadowOffset = CGSize.zero {
        didSet {
            self.updateShadowOffset()
        }
    }
    @IBInspectable var masksToBounds = true {
        didSet {
            self.updateMasksToBounds()
        }
    }
    
    func updateCornerRadius() {
        self.shapeLayer.cornerRadius = self.cornerRadius
    }
    
    func updateShadowColor() {
        self.shapeLayer.shadowColor = self.shadowColor
    }
    
    func updateShadowOpacity() {
        self.shapeLayer.shadowOpacity = self.shadowOpacity
    }
    
    func updateShadowRadius() {
        self.shapeLayer.shadowRadius = self.shadowRadius
    }
    
    func updateShadowOffset() {
        self.shapeLayer.shadowOffset = self.shadowOffset
    }
    
    func updateMasksToBounds() {
        self.shapeLayer.masksToBounds = self.masksToBounds
    }
}
