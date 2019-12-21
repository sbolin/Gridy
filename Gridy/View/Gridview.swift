//
//  Gridview.swift
//  Gridy
//
//  Created by Scott Bolin on 11/28/19.
//  Copyright © 2019 Scott Bolin. All rights reserved.
//

import UIKit

class Gridview: UIView {
    
    let windowPath = UIBezierPath()
    var innerWindowPath = CGRect()
    
    let hgrid1Path = UIBezierPath()
    let hgrid2Path = UIBezierPath()
    let hgrid3Path = UIBezierPath()
    
    let vgrid1Path = UIBezierPath()
    let vgrid2Path = UIBezierPath()
    let vgrid3Path = UIBezierPath()
    
    override func draw(_ rect: CGRect)
    {
        // General Declarations
        // Color Declarations
        let backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        
        // Variable Declarations
        let leading: CGFloat = 20
        
        // pass in proper frame
        let screenWidth: CGFloat = self.frame.width
        let screenHeight: CGFloat = self.frame.height
        let innerWindowWidth = screenWidth - 2 * leading
        let innerWindowDepth = innerWindowWidth
        let innerWindowTop: CGFloat = (screenHeight - innerWindowDepth) / 2.0
        let innerWindowBottom: CGFloat = screenHeight - (screenHeight - innerWindowDepth) / 2.0
        
        let hgrid1y: CGFloat = innerWindowTop + innerWindowDepth / 4.0
        let hgrid2y: CGFloat = innerWindowTop + innerWindowDepth / 2.0
        let hgrid3y: CGFloat = innerWindowTop + 3 * innerWindowDepth / 4.0
        let trailing: CGFloat = leading
        let innerWindowRight: CGFloat = screenWidth - trailing
        let innerWindowLeft: CGFloat = leading
        let vgrid1x: CGFloat = leading + innerWindowWidth / 4.0
        let vgrid2x: CGFloat = leading + innerWindowWidth / 2.0
        let vgrid3x: CGFloat = leading + 3 * innerWindowWidth / 4.0
        
        // window Drawing
        // Inner window
        windowPath.move(to: CGPoint(x: innerWindowRight, y: innerWindowTop))
        windowPath.addLine(to: CGPoint(x: innerWindowLeft, y: innerWindowTop))
        windowPath.addLine(to: CGPoint(x: innerWindowLeft, y: innerWindowBottom))
        windowPath.addLine(to: CGPoint(x: innerWindowRight, y: innerWindowBottom))
        windowPath.addLine(to: CGPoint(x: innerWindowRight, y: innerWindowTop))
        UIColor.green.setStroke()
        windowPath.lineWidth = 2.0
        windowPath.stroke()
        windowPath.close()
        
        innerWindowPath = windowPath.bounds
        
        // Outer window
        windowPath.move(to: CGPoint(x: screenWidth, y: 0))
        windowPath.addCurve(to: CGPoint(x: screenWidth, y: screenHeight), controlPoint1: CGPoint(x: screenWidth, y: 0), controlPoint2: CGPoint(x: screenWidth, y: screenHeight))
        windowPath.addLine(to: CGPoint(x: 0, y: screenHeight))
        windowPath.addLine(to: CGPoint(x: 0, y: 0))
        windowPath.addLine(to: CGPoint(x: screenWidth, y: 0))
        windowPath.addLine(to: CGPoint(x: screenWidth, y: 0))
        windowPath.close()
        backgroundColor.setFill()
        windowPath.fill()
        //        windowPath.stroke()
        windowPath.close()
        
        // Draw Grids
        // hgrid1 Drawing
        hgrid1Path.move(to: CGPoint(x: leading, y: hgrid1y))
        hgrid1Path.addLine(to: CGPoint(x: innerWindowWidth + leading, y: hgrid1y))
        UIColor.darkGray.setStroke()
        hgrid1Path.lineWidth = 0.5
        hgrid1Path.stroke()
        hgrid1Path.close()
        
        // hgrid2 Drawing
        hgrid2Path.move(to: CGPoint(x: leading, y: hgrid2y))
        hgrid2Path.addLine(to: CGPoint(x: innerWindowWidth + leading, y: hgrid2y))
        UIColor.darkGray.setStroke()
        hgrid2Path.lineWidth = 0.5
        hgrid2Path.stroke()
        hgrid2Path.close()
        
        // hgrid3 Drawing
        hgrid3Path.move(to: CGPoint(x: leading, y: hgrid3y))
        hgrid3Path.addLine(to: CGPoint(x: innerWindowWidth + leading, y: hgrid3y)) //not sure why need to add 20
        UIColor.darkGray.setStroke()
        hgrid3Path.lineWidth = 0.5
        hgrid3Path.stroke()
        hgrid3Path.close()
        
        // vgrid1 Drawing
        vgrid1Path.move(to: CGPoint(x: vgrid1x, y: innerWindowTop))
        vgrid1Path.addLine(to: CGPoint(x: vgrid1x, y: innerWindowBottom))
        UIColor.darkGray.setStroke()
        vgrid1Path.lineWidth = 1.0
        vgrid1Path.stroke()
        vgrid1Path.close()
        
        // vgrid2 Drawing
        vgrid2Path.move(to: CGPoint(x: vgrid2x, y: innerWindowTop))
        vgrid2Path.addLine(to: CGPoint(x: vgrid2x, y: innerWindowBottom))
        UIColor.darkGray.setStroke()
        vgrid2Path.lineWidth = 1.0
        vgrid2Path.stroke()
        vgrid2Path.close()
        
        // vgrid3 Drawing
        vgrid3Path.move(to: CGPoint(x: vgrid3x, y: innerWindowTop))
        vgrid3Path.addLine(to: CGPoint(x: vgrid3x, y: innerWindowBottom))
        UIColor.darkGray.setStroke()
        vgrid3Path.lineWidth = 1.0
        vgrid3Path.stroke()
        vgrid3Path.close()
    }
}
