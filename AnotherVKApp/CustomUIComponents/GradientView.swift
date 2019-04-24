//
//  GradientView.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 03/03/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit
@IBDesignable class GradientView: UIView {
    //Изменим класс слоя на CAGradientLayer
    override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    //Вычисляемая переменная для удобной работы со слоем
    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
    
    //Свойства, отвечающие за параметры градиента
    //Начальный цвет градиента
    @IBInspectable var startColor: UIColor = .white {
        didSet {
            self.updateColors()
        }
    }
    
    //Конечный цвет градиента
    @IBInspectable var endColor: UIColor = .black {
        didSet {
            self.updateColors()
        }
    }
    
    //Начало градиента
    @IBInspectable var startLocation: CGFloat = 0 {
        didSet {
            self.updateLocation()
        }
    }
    
    //Конец градиента
    @IBInspectable var endLocation: CGFloat = 1 {
        didSet {
            self.updateLocation()
        }
    }
    
    //Точка начала градиента
    @IBInspectable var startPoint: CGPoint = .zero {
        didSet {
            self.updateStartPoint()
        }
    }
    
    //Точка конца градиента
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet {
            self.updateEndPoint()
        }
    }
    
    //Методы, обновляющие параметры слоя с градиентом
    func updateLocation() {
        self.gradientLayer.locations = [self.startLocation as NSNumber, self.endLocation as NSNumber]
    }
    
    func updateColors() {
        self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
    }
    
    func updateStartPoint() {
        self.gradientLayer.startPoint = startPoint
    }
    
    func updateEndPoint() {
        self.gradientLayer.endPoint = endPoint
    }
}
