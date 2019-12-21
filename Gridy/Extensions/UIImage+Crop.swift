//
//  Crop.swift
//  Gridy
//
//  Created by Scott Bolin on 11/30/19.
//  Copyright © 2019 Scott Bolin. All rights reserved.
//
// 
import UIKit

extension UIImage{
    func cropToBounds(posX: CGFloat, posY: CGFloat, width: CGFloat, height: CGFloat) -> UIImage {
        
        let cgimage = self.cgImage!
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: width, height: height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        let image = UIImage(cgImage: imageRef)
        
        return image
        
    }
}

