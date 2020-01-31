//
//  UIImage+Border.swift
//  Gridy
//
//  Created by Scott Bolin on 1/31/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

extension UIImage {
    func addBorder(border: CGFloat, color: UIColor) -> UIImage {
        let imageSize = self.size
        let tempImage = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: imageSize.width + border, height: imageSize.height + border)))
        tempImage.contentMode = .center
        tempImage.image = self
        tempImage.layer.borderWidth = border
        tempImage.layer.borderColor = color.cgColor
        tempImage.layer.cornerRadius = 3
                        
        UIGraphicsBeginImageContextWithOptions(tempImage.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        tempImage.layer.render(in: context)
        guard let finalImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()

        return finalImage
    }
}

