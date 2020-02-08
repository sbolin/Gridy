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
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
        
    override func viewDidLoad() {
            super.viewDidLoad()
                        
        // set up buttons
        let cornerRadius = CGFloat(8)
        startButton.layer.cornerRadius = cornerRadius
        resetViewButton.layer.cornerRadius = cornerRadius
        newPictureButton.layer.cornerRadius = cornerRadius
        
        // set up initial picture
        selectedImage.image = passedImage
        selectedImagePixelWidth = passedImage.size.width
        selectedImagePixelHeight = passedImage.size.height
        
        // set up gestures
        configureGestureRecognizer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
        
        removeBlurEffect()
        setBlurView()
    }
    
        //MARK: - Setup blur view, remove blur effects
    func setBlurView() {
        let blurView = UIVisualEffectView()
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
        
        //        view.insertSubview(blurView, belowSubview: selectedImage)
        view.insertSubview(blurView, at: 1)
        //        view.addSubview(blurView)
    }
            
        func removeBlurEffect() {
            let blurredEffectViews = view.subviews.filter{$0 is UIVisualEffectView}
            blurredEffectViews.forEach{ blurView in
                blurView.removeFromSuperview()
            }
        }
    
    //MARK: - Configure Gesture Recognizers
    func configureGestureRecognizer() {
        // create pan gesture recognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(sender:)))
        panGestureRecognizer.cancelsTouchesInView = true
        panGestureRecognizer.delegate = self
        selectedImage.addGestureRecognizer(panGestureRecognizer)
        
        //create rotation gesture recognizer
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateImageView(sender:)))
        rotationGestureRecognizer.cancelsTouchesInView = true
        rotationGestureRecognizer.delegate = self
        selectedImage.addGestureRecognizer(rotationGestureRecognizer)
        
        //create scale gesture recognizer
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scaleImageView(sender:)))
        pinchGestureRecognizer.cancelsTouchesInView = true
        pinchGestureRecognizer.delegate = self
        selectedImage.addGestureRecognizer(pinchGestureRecognizer)
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
    @objc func rotateImageView(sender: UIRotationGestureRecognizer) {
        selectedImage.transform = selectedImage.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    @objc func scaleImageView(sender: UIPinchGestureRecognizer) {
        let selectedImageAspectRatio = selectedImagePixelWidth / selectedImagePixelHeight
        let selectedImageScaledHeight = selectedImage.frame.height
        let selectedImageScaledWidth = selectedImageAspectRatio * selectedImageScaledHeight
        
        print("scaled image: \(selectedImageScaledWidth) x \(selectedImageScaledHeight)")
        
        if (selectedImageScaledWidth > maskView.frame.width) && (selectedImageScaledHeight > maskView.frame.height) {
           selectedImage.transform = selectedImage.transform.scaledBy(x: sender.scale, y: sender.scale)
        }
        sender.scale = 1.0
    }
    
    // MARK: - GestureRecognizers Protocols
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // conditions for simulanious gestures
        if gestureRecognizer.view != selectedImage {
            return false
        }
        // neither of the recognized gestures should be a tap gesture
        if gestureRecognizer is UITapGestureRecognizer
            || otherGestureRecognizer is UITapGestureRecognizer {
            return false
        }
        return true
    }
    
    //MARK: - GestureRecognizer functions
    @objc func moveImageView(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: selectedImage.superview)
        
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        if sender.state == .ended {
            // set up limits on pan - choosenImage must be within by maskView
            var finalPoint = CGPoint(x: sender.view!.center.x, y: sender.view!.center.y)

            let minX = maskView.frame.minX
            let maxX = maskView.frame.maxX
            let minY = maskView.frame.minY
            let maxY = maskView.frame.maxY
                        
            // calculate scaled image (as scalled to fit within choosenImage view)
            let selectedImageAspectRatio = selectedImagePixelWidth / selectedImagePixelHeight
            let selectedImageScaledHeight = selectedImage.frame.height
            let selectedImageScaledWidth = selectedImageAspectRatio * selectedImageScaledHeight
            
            if finalPoint.x - selectedImageScaledWidth / 2 > minX { finalPoint.x = minX +  selectedImageScaledWidth / 2 }
            if finalPoint.x + selectedImageScaledWidth / 2 < maxX { finalPoint.x = maxX - selectedImageScaledWidth / 2 }
            if finalPoint.y - selectedImageScaledHeight / 2 > minY { finalPoint.y = minY + selectedImageScaledHeight / 2 }
            if finalPoint.y + selectedImageScaledHeight / 2 < maxY { finalPoint.y = maxY - selectedImageScaledHeight / 2 }
            
            UIView.animate(withDuration: 1.0, delay: 0, options: UIView.AnimationOptions.curveEaseOut,
                           animations: { sender.view!.center = finalPoint },
                           completion: nil)
        }
    }
    
    //MARK: - Actions
    @IBAction func startTapped(_ sender: UIButton) {
        imageToPlay = composeCreationImage()
        performSegue(withIdentifier: "toGame", sender: self)
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        selectedImage.transform = selectedImage.transform.translatedBy(x: -currentPostion.x, y: -currentPostion.y)
    }
    @IBAction func newPictureTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
