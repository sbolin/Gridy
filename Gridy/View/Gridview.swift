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
    
    var innerWindowWidth: CGFloat = 0.0
    var innerWindowDepth: CGFloat = 0.0
    var innerWindowTop: CGFloat = 0.0
    var innerWindowBottom: CGFloat = 0.0
    var innerWindowRight: CGFloat = 0.0
    var innerWindowLeft: CGFloat = 0.0
    
    override func draw(_ rect: CGRect)
    {
        // General Declarations
        // Color Declarations
        clearsContextBeforeDrawing = true
        let backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
        
        // Variable Declarations
        
        var leadingOffset: CGFloat = 20
        if UIDevice.current.model.hasPrefix("iPad") {
            leadingOffset = 100
        }
        var trailingOffset: CGFloat = leadingOffset
        
        // pass in proper frame
        let screenWidth: CGFloat = self.bounds.width
        let screenHeight: CGFloat = self.bounds.height
        
        print("Gridview: draw:rect: screenWidth: \(screenWidth)")
        print("Gridview: draw:rect: screenHeight: \(screenHeight)")
        
        if screenWidth > screenHeight {
            print("Gridview: Landscape")
            print("Gridview: innerWindowPath: \(innerWindowPath)")
            innerWindowDepth = screenHeight - leadingOffset - trailingOffset
            innerWindowWidth = innerWindowDepth
            innerWindowTop = leadingOffset
            innerWindowBottom = screenHeight - trailingOffset
            leadingOffset = (screenWidth - innerWindowWidth) / 2.0
            trailingOffset = leadingOffset
            
        } else {
            print("Gridview: Portrait")
            print("Gridview: innerWindowPath: \(innerWindowPath)")
            innerWindowWidth = screenWidth - leadingOffset - trailingOffset
            innerWindowDepth = innerWindowWidth
            innerWindowTop = (screenHeight - innerWindowDepth) / 2.0
            innerWindowBottom = screenHeight - (screenHeight - innerWindowDepth) / 2.0
        }
        innerWindowRight = screenWidth - trailingOffset
        innerWindowLeft = leadingOffset
        
        print("Gridview: innerWindowLeft: \(innerWindowLeft)")
        print("Gridview: innerWindowRight: \(innerWindowRight)")
        print("Gridview: innerWindowTop: \(innerWindowTop)")
        print("Gridview: innerWindowBottom: \(innerWindowBottom)")
        print("Gridview: innerWindowDepth: \(innerWindowDepth)")
        print("Gridview: innerWindowWidth: \(innerWindowWidth)")


        
        let hgrid1y: CGFloat = innerWindowTop + innerWindowDepth / 4.0
        let hgrid2y: CGFloat = innerWindowTop + innerWindowDepth / 2.0
        let hgrid3y: CGFloat = innerWindowTop + 3.0 * innerWindowDepth / 4.0


        let vgrid1x: CGFloat = leadingOffset + innerWindowWidth / 4.0
        let vgrid2x: CGFloat = leadingOffset + innerWindowWidth / 2.0
        let vgrid3x: CGFloat = leadingOffset + 3.0 * innerWindowWidth / 4.0
        
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
        windowPath.addLine(to: CGPoint(x: screenWidth, y: screenHeight))
        windowPath.addLine(to: CGPoint(x: 0, y: screenHeight))
        windowPath.addLine(to: CGPoint(x: 0, y: 0))
        windowPath.addLine(to: CGPoint(x: screenWidth, y: 0))
        windowPath.close()
        backgroundColor.setFill()
        windowPath.fill()

        
        
        // Draw Grids
        // hgrid1 Drawing
        hgrid1Path.move(to: CGPoint(x: leadingOffset, y: hgrid1y))
        hgrid1Path.addLine(to: CGPoint(x: innerWindowWidth + leadingOffset, y: hgrid1y))
        UIColor.darkGray.setStroke()
        hgrid1Path.lineWidth = 0.5
        hgrid1Path.stroke()
        hgrid1Path.close()
        
        // hgrid2 Drawing
        hgrid2Path.move(to: CGPoint(x: leadingOffset, y: hgrid2y))
        hgrid2Path.addLine(to: CGPoint(x: innerWindowWidth + leadingOffset, y: hgrid2y))
        UIColor.darkGray.setStroke()
        hgrid2Path.lineWidth = 0.5
        hgrid2Path.stroke()
        hgrid2Path.close()
        
        // hgrid3 Drawing
        hgrid3Path.move(to: CGPoint(x: leadingOffset, y: hgrid3y))
        hgrid3Path.addLine(to: CGPoint(x: innerWindowWidth + leadingOffset, y: hgrid3y)) //not sure why need to add 20
        UIColor.darkGray.setStroke()
        hgrid3Path.lineWidth = 0.5
        hgrid3Path.stroke()
        hgrid3Path.close()
        
        // vgrid1 Drawing
        vgrid1Path.move(to: CGPoint(x: vgrid1x, y: innerWindowTop))
        vgrid1Path.addLine(to: CGPoint(x: vgrid1x, y: innerWindowBottom))
        UIColor.darkGray.setStroke()
        vgrid1Path.lineWidth = 0.5
        vgrid1Path.stroke()
        vgrid1Path.close()
        
        // vgrid2 Drawing
        vgrid2Path.move(to: CGPoint(x: vgrid2x, y: innerWindowTop))
        vgrid2Path.addLine(to: CGPoint(x: vgrid2x, y: innerWindowBottom))
        UIColor.darkGray.setStroke()
        vgrid2Path.lineWidth = 0.5
        vgrid2Path.stroke()
        vgrid2Path.close()
        
        // vgrid3 Drawing
        vgrid3Path.move(to: CGPoint(x: vgrid3x, y: innerWindowTop))
        vgrid3Path.addLine(to: CGPoint(x: vgrid3x, y: innerWindowBottom))
        UIColor.darkGray.setStroke()
        vgrid3Path.lineWidth = 0.5
        vgrid3Path.stroke()
        vgrid3Path.close()
    }
}
