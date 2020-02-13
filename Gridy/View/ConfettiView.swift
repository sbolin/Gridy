//
//  ConfettiView.swift
//  Gridy
//
//  Created by Scott Bolin on 1/10/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class ConfettiView: UIView {
    
    var confettiImage: UIImage?
    
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    
    func makeEmitterCell(color: UIColor, velocity: CGFloat, scale: CGFloat) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 4.0
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = velocity
        cell.velocityRange = velocity / 4
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = .pi
        cell.spinRange = .pi
        cell.scale = scale
        cell.scaleRange = scale / 3
        cell.contents = confettiImage?.cgImage
        return cell
    }
    
    override func layoutSubviews() {
        
        let confettiEmitter =  self.layer as! CAEmitterLayer
        
        confettiEmitter.emitterShape = .line
        confettiEmitter.emitterPosition = CGPoint(x: bounds.midX, y: 0)
        confettiEmitter.emitterSize = CGSize(width: bounds.size.width, height: 1)
        
        let red_near = makeEmitterCell(color: UIColor.red, velocity: 175, scale: 0.025)
        let green_near = makeEmitterCell(color: UIColor.green, velocity: 175, scale: 0.025)
        let blue_near = makeEmitterCell(color: UIColor.blue, velocity: 175, scale: 0.025)
        let yellow_near = makeEmitterCell(color: UIColor.yellow, velocity: 175, scale: 0.025)
        let cyan_near = makeEmitterCell(color: UIColor.cyan, velocity: 175, scale: 0.025)
        let purple_near = makeEmitterCell(color: UIColor.purple, velocity: 175, scale: 0.025)
        let orange_near = makeEmitterCell(color: UIColor.orange, velocity: 175, scale: 0.025)
        
        let red_mid = makeEmitterCell(color: UIColor.red, velocity: 125, scale: 0.0175)
        let green_mid = makeEmitterCell(color: UIColor.green, velocity: 125, scale: 0.0175)
        let blue_mid = makeEmitterCell(color: UIColor.blue, velocity: 125, scale: 0.0175)
        let yellow_mid = makeEmitterCell(color: UIColor.yellow, velocity: 125, scale: 0.0175)
        
        let red_far = makeEmitterCell(color: UIColor.red, velocity: 75, scale: 0.01)
        let green_far = makeEmitterCell(color: UIColor.green, velocity: 75, scale: 0.01)
        let blue_far = makeEmitterCell(color: UIColor.blue, velocity: 75, scale: 0.01)
        
        confettiEmitter.emitterCells = [red_near, green_near, blue_near, yellow_near, cyan_near, purple_near, orange_near, red_mid, green_mid, blue_mid, yellow_mid, red_far, green_far, blue_far]
        
    }
}
