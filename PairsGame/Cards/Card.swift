//
//  Card.swift
//  PairsGame
//
//  Created by Filip Němeček on 12/05/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

class Card: UIView {

    enum CardState {
        case hidden
        case revealed
        case removed
    }
    
    weak var delegate: CardDelegate?
    
    var text: String? {
        didSet {
            textLabel?.text = text
        }
    }
    
    var hasValue: Bool {
        return text != nil
    }
    
    private let cardCornerRadius: CGFloat = 15
    
    private var imageView: UIImageView!
    
    private var textLabel: UILabel!
    
    private var state: CardState = .hidden
    
    private var hiddenView: UIView!
    private var revealedView: UIView!
    
    let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        
        isUserInteractionEnabled = true
        
        hiddenView = UIView(frame: frame)
        hiddenView.layer.cornerRadius = cardCornerRadius
        revealedView = UIView(frame: frame)
        revealedView.layer.cornerRadius = cardCornerRadius
        revealedView.layer.opacity = 0
        
        revealedView.translatesAutoresizingMaskIntoConstraints = false
        revealedView.backgroundColor = UIColor.lightGray
        revealedView.isUserInteractionEnabled = true
        addSubview(revealedView)
        
        hiddenView.translatesAutoresizingMaskIntoConstraints = false
        hiddenView.backgroundColor = UIColor.darkGray
        hiddenView.isUserInteractionEnabled = true
        addSubview(hiddenView)
        
        hiddenView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        hiddenView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        hiddenView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        hiddenView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        revealedView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        revealedView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        revealedView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        revealedView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setupImageView()
        setupLabel()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        hiddenView.addGestureRecognizer(tapRecognizer)
        
        setupMotionEffect()
    }
    
    func matchesWith(other card: Card) -> Bool {
        return self.tag == card.tag
    }
    
    func removeFromDeck() {
        state = .removed
        
        // animate to remove
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
    
    @objc func tapped(recognizer: UITapGestureRecognizer) {
        guard state == .hidden else {
            return
        }
        
        guard delegate?.canRevealCard ?? false else {
            shakeCard()
            return
        }
        
        delegate?.cardRevealed(self)
        flipCard()
    }
    
    func flipCard() {
        let viewToHide: UIView
        let viewToShow: UIView
        
        if state == .hidden {
            viewToHide = hiddenView
            viewToShow = revealedView
        } else {
            viewToHide = revealedView
            viewToShow = hiddenView
        }
        
        UIView.transition(with: viewToHide, duration: 1.0, options: transitionOptions, animations: {
            viewToHide.layer.opacity = 0
        })
      
        UIView.transition(with: viewToShow, duration: 1.0, options: transitionOptions, animations: {
            viewToShow.alpha = 1
            if self.state == .hidden {
                self.state = .revealed
            } else {
                self.state = .hidden
            }
        })
    }
    
    private func shakeCard() {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y))
        
        layer.add(shakeAnimation, forKey: "shakeAnimation")
    }
    
    private func setupImageView() {
        imageView = UIImageView(frame: frame.insetBy(dx: 5, dy: 5))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        hiddenView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: hiddenView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: hiddenView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: hiddenView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: hiddenView.bottomAnchor).isActive = true
    }
    
    private func setupLabel() {
        textLabel = UILabel(frame: frame.insetBy(dx: 10, dy: 10))
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        revealedView.addSubview(textLabel)
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.darkGray
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        textLabel.leadingAnchor.constraint(equalTo: revealedView.leadingAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: revealedView.trailingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: revealedView.topAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: revealedView.bottomAnchor).isActive = true
    }
    
    func setPattern(_ pattern: UIImage) {
        imageView.image = pattern
    }
    
    private let maximumMotionEffectStrength: Float = 20
    
    private func setupMotionEffect() {
        let horizontalEffect = UIInterpolatingMotionEffect(
            keyPath: "center.x",
            type: .tiltAlongHorizontalAxis)
        horizontalEffect.minimumRelativeValue = -maximumMotionEffectStrength
        horizontalEffect.maximumRelativeValue = maximumMotionEffectStrength
        
        let verticalEffect = UIInterpolatingMotionEffect(
            keyPath: "center.y",
            type: .tiltAlongVerticalAxis)
        verticalEffect.minimumRelativeValue = -maximumMotionEffectStrength
        verticalEffect.maximumRelativeValue = maximumMotionEffectStrength
        
        let effectGroup = UIMotionEffectGroup()
        effectGroup.motionEffects = [horizontalEffect, verticalEffect]
        
        hiddenView.addMotionEffect(effectGroup)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
