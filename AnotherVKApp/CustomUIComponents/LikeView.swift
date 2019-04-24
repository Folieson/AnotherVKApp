//
//  LikeView.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 03/03/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit

enum LikeStatus:Int {
    case neutral
    case liked
}

@IBDesignable class LikeView: UIControl {
    
    private var controlComponents: [UIView] = []
    
    private var likeCounter: Int = 20 {
        didSet {
            updateLabelText()
            //self.sendActions(for: .valueChanged)
        }
    }
    
    let button = UIButton()
    
    let label = UILabel()
    private var likeStatus: LikeStatus = .neutral
    //private var button = UIButton(type: UIButton.ButtonType.custom)
    private var stackView: UIStackView!
    //private var buttonImage = UIImage(named: "like")
    private let likedImage = UIImage(named: "liked")
    private let unlikedImage = UIImage(named: "unliked")
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        //let button = UIButton(type: .custom)
        //button.setImage(unlikedImage, for: .normal)
        self.button.setImage(unlikedImage, for: .normal)
        self.button.setImage(likedImage, for: .selected)
        //button.setTitleColor(.lightGray, for: .normal)
        //button.setTitleColor(.white, for: .selected)
        //self.button.setTitleColor(.gray, for: .normal)
        //self.button.backgroundColor = UIColor.gray
        //self.button.frame.size = CGSize(width: 50, height: 50)
        //self.label.font.
        button.translatesAutoresizingMaskIntoConstraints = false
        
//        button.addConstraint(NSLayoutConstraint(item: self.button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.button, attribute: NSLayoutConstraint.Attribute.width, multiplier: self.button.frame.size.height / self.button.frame.size.width, constant: 0))
////        button.addConstraint(NSLayoutConstraint(item: self.button,
////                                                attribute: NSLayoutConstraint.Attribute.height,
////                                                relatedBy: NSLayoutConstraint.Relation.equal,
////                                                toItem: self.button,
////                                                attribute: NSLayoutConstraint.Attribute.width,
////                                                multiplier: self.button.frame.size.height / self.button.frame.size.width,
////                                                constant: 0))
        //button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1).isActive = true
        
        //button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        self.button.addTarget(self, action: #selector(selectLike(_:)), for: .touchUpInside)
        //button.sizeThatFits(label.intrinsicContentSize)
        //label.intrinsicContentSize
        //self.button.setTitleColor(.gray, for: .normal)
        updateLabelText()
        
        self.controlComponents.append(label)
        self.controlComponents.append(button)
        stackView = UIStackView(arrangedSubviews: controlComponents)
        stackView.autoresizesSubviews = true
    
        self.addSubview(stackView)
        
        //stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
    }
    
   private func updateLabelText() {
        self.label.text = String(likeCounter)
    }
    
    @objc private func selectLike(_ sender: UIButton) {
        //let button = sender
        //button.isHighlighted
        if self.button.isSelected == true {
            self.likeCounter -= 1
            self.button.isSelected = false
        } else {
            self.likeCounter += 1
            self.button.isSelected = true
        }
//        switch self.likeStatus {
//        case .neutral:
//            self.likeCounter += 1
//            self.likeStatus = .liked
//            self.button.backgroundColor = UIColor.red
//            break
//        case .liked:
//            self.likeCounter -= 1
//            self.likeStatus = .neutral
//            self.button.backgroundColor = UIColor.gray
//
//            break
//        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
}
