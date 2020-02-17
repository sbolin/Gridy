//
//  EditorViewController.swift
//  Gridy
//
//  Created by Scott Bolin on 11/9/19.
//  Copyright © 2019 Scott Bolin. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var maskView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetViewButton: UIButton!
    @IBOutlet weak var newPictureButton: UIButton!
    
    var currentPostion = CGPoint()
    var selectedImagePixelHeight = CGFloat()
    var selectedImagePixelWidth = CGFloat()
    
    var passedImage = UIImage()
    var imageToPlay = UIImage()
    var blurView = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up buttons
        let cornerRadius = CGFloat(8)
        startButton.layer.cornerRadius = cornerRadius
        resetViewButton.layer.cornerRadius = cornerRadius
        newPictureButton.layer.cornerRadius = cornerRadius
        
        // set up initial picture
        selectedImage.image = passedImage
        //
        selectedImage.clipsToBounds = false
        //
        selectedImagePixelWidth = passedImage.size.width
        selectedImagePixelHeight = passedImage.size.height
        
        // set up gestures
        configureGestureRecognizer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setBlurView()
    }
    
    //MARK: - Setup blur view, remove blur effects
    func setBlurView() {
        
        blurView.removeFromSuperview()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: UIBlurEffect.Style.light) //systemUltraThinMaterial also good
        
        // set up mask
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(rect: view.bounds)
        
        let maskSide = min(maskView.bounds.width, maskView.bounds.height)
        let maskSize = CGSize(width: maskView.bounds.width, height: maskView.bounds.height)
        let maskOrigin = CGPoint(x: CGFloat(view.center.x) - (maskSide / 2),
                                 y: CGFloat(view.center.y) - (maskSide / 2))
        
        let mask = UIBezierPath(rect: CGRect(origin: maskOrigin, size: maskSize))
        
        path.append(mask)
        
        maskLayer.path = path.cgPath
        maskLayer.fillColor = UIColor.white.cgColor
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        blurView.layer.mask = maskLayer
        blurView.clipsToBounds = true
        
        view.insertSubview(blurView, at: 1)
    }
    
    //MARK: - Configure Gesture Recognizers
    func configureGestureRecognizer() {
        // create pan gesture recognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(sender:)))
        panGestureRecognizer.cancelsTouchesInView = true
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
        
        //create rotation gesture recognizer
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateImageView(sender:)))
        rotationGestureRecognizer.cancelsTouchesInView = true
        rotationGestureRecognizer.delegate = self
        view.addGestureRecognizer(rotationGestureRecognizer)
        
        //create scale gesture recognizer
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scaleImageView(sender:)))
        pinchGestureRecognizer.cancelsTouchesInView = true
        pinchGestureRecognizer.delegate = self
        view.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    func composeCreationImage() -> UIImage {
        
        // set up screen capture size
        let xloc = -maskView.frame.minX - 2
        let yloc = -maskView.frame.minY - 2
        let clipSize = maskView.frame.size
        
        let contextSize = view.bounds.size
        let rectSize = CGRect(x: xloc, y: yloc, width: contextSize.width + 4, height: contextSize.height + 4)
        
        // set up screen capture image
        UIGraphicsBeginImageContextWithOptions(clipSize, false, 0)
        view.drawHierarchy(in: rectSize, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return screenshot
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame" {
            let destinationVC = segue.destination as! PlayfieldViewController
            destinationVC.selectedImage = imageToPlay
        }
    }
    
    // MARK: - GestureRecognizers
    // Move
    @objc func moveImageView(sender: UIPanGestureRecognizer) {
        
        guard let moveableView = selectedImage else { return }
        let translation = sender.translation(in: moveableView.superview)
        
        moveableView.center = CGPoint(x: moveableView.center.x + translation.x, y: moveableView.center.y + translation.y)
        
        sender.setTranslation(CGPoint.zero, in: view)
        
        if sender.state == .ended {
            
            // set up limits on pan - choosenImage must be within by maskView
            var finalPoint = CGPoint(x: moveableView.center.x, y: moveableView.center.y)
            
            let minX = maskView.frame.minX
            let maxX = maskView.frame.maxX
            let minY = maskView.frame.minY
            let maxY = maskView.frame.maxY
            
            let moveableViewWidth = moveableView.frame.width
            let moveableViewHeight = moveableView.frame.height
            let selectedImageScaledWidth = selectedImage.bounds.width
            let selectedImageScaledHeight = selectedImage.bounds.height
            var scaledWidth = moveableViewWidth
            var scaledHeight = moveableViewHeight
            
            let wScale = selectedImageScaledWidth / selectedImagePixelWidth
            let hScale = selectedImageScaledHeight / selectedImagePixelHeight
            
            if hScale > wScale {
                scaledHeight = hScale * selectedImagePixelHeight
                scaledWidth = hScale * selectedImagePixelWidth
            } else {
                scaledHeight = wScale * selectedImagePixelHeight
                scaledWidth = wScale * selectedImagePixelWidth
            }
            
            let leadingEdge = finalPoint.x - scaledWidth / 2
            let trailingEdge = finalPoint.x + scaledWidth / 2
            let topEdge = finalPoint.y - scaledHeight / 2
            let bottomEdge = finalPoint.y + scaledHeight / 2
            
            if leadingEdge > minX { finalPoint.x = minX + scaledWidth / 2 }
            if trailingEdge < maxX { finalPoint.x = maxX - scaledWidth / 2 }
            if topEdge > minY { finalPoint.y = minY +  scaledHeight / 2 }
            if bottomEdge < maxY { finalPoint.y = maxY -  scaledHeight / 2 }
            
            UIView.animate(withDuration: 1.0, delay: 0, options: UIView.AnimationOptions.curveEaseOut,
                           animations: { moveableView.center = finalPoint },
                           completion: nil)
        }
    }
    
    // rotate
    @objc func rotateImageView(sender: UIRotationGestureRecognizer) {
        selectedImage.transform = selectedImage.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    // scale
    @objc func scaleImageView(sender: UIPinchGestureRecognizer) {
        //        let selectedImageAspectRatio = selectedImagePixelWidth / selectedImagePixelHeight
        //        let selectedImageScaledHeight = selectedImage.frame.height
        //        let selectedImageScaledWidth = selectedImageAspectRatio * selectedImageScaledHeight
        
        //        if (selectedImageScaledWidth > maskView.frame.width) && (selectedImageScaledHeight > maskView.frame.height) {
        //        selectedImage.transform = selectedImage.transform.scaledBy(x: sender.scale, y: sender.scale)
        print("scale: \(sender.scale)")
        selectedImage.transform = selectedImage.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
    
    // MARK: - GestureRecognizers Protocols
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // conditions for simulanious gestures
        if gestureRecognizer.view != selectedImage { return false }
        // neither of the recognized gestures should be a tap gesture
        if gestureRecognizer is UITapGestureRecognizer
            || otherGestureRecognizer is UITapGestureRecognizer {
            return false
        }
        return true
    }
    
    //MARK: - Actions
    // start
    @IBAction func startTapped(_ sender: UIButton) {
        imageToPlay = composeCreationImage()
        performSegue(withIdentifier: "toGame", sender: self)
    }
    // reset
    @IBAction func resetTapped(_ sender: UIButton) {
        
        let moveX = view.center.x - selectedImage.center.x
        let moveY = view.center.y - selectedImage.center.y
        selectedImage.transform = selectedImage.transform.translatedBy(x: moveX, y: moveY)
    }
    // new picture
    @IBAction func newPictureTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
