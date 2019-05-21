//
//  RectanglePatternGenerator.swift
//  PairsGame
//
//  Created by Filip Němeček on 12/05/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

class RectanglePatternGenerator: PatternGenerator {
    func generateRandomPattern(withSize size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { (ctx) in
            
            let randomFlatColor = UIColor(hue: CGFloat.random(in: 0...1), saturation: 0.30, brightness: 0.50, alpha: 1)
            ctx.cgContext.setStrokeColor(randomFlatColor.cgColor)
            
            ctx.cgContext.setLineWidth(CGFloat.random(in: 1...3))
            
            let initialOrigin = CGPoint(x: 10, y: 10)
            let initialWidth = size.width - initialOrigin.x * 2
            let initialHeight = size.height - initialOrigin.y * 2
            
            var currentWidth = initialWidth
            var currentHeight = initialHeight
            var currentOrigin = initialOrigin
            
            let sizeStep = CGFloat.random(in: 5...9)
            
            let rectangleCount = Int.random(in: 5 ... 8)
            
            for _ in 0 ..< rectangleCount {
                ctx.cgContext.addRect(CGRect(origin: currentOrigin, size: CGSize(width: currentWidth, height: currentHeight)))
                
                currentOrigin.x += sizeStep
                currentOrigin.y += sizeStep
                
                currentHeight = size.height - currentOrigin.y * 2
                currentWidth = size.width - currentOrigin.x * 2
                
                ctx.cgContext.strokePath()
            }
        }
        
        return image
    }
}
