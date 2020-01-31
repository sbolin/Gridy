//
//  EditorViewController.swift
//  Gridy
//
//  Created by Scott Bolin on 11/9/19.
//  Copyright © 2019 Scott Bolin. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var gridView: Gridview!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetViewButton: UIButton!
    @IBOutlet weak var newPictureButton: UIButton!
    
    var initialImageViewOffset = CGPoint()
    var currentPostion = CGPoint()
    var selectedImagePixelHeight = CGFloat()
    var selectedImagePixelWidth = CGFloat()
    
    var passedImage = UIImage()
    var imageToPlay = UIImage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
        
//        override func viewDidLayoutSubviews() {
//          super.viewDidLayoutSubviews()
            
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        
        print("\nEditorViewController: viewDidAppear\n")
        
        // set up buttons
        let cornerRadius = CGFloat(12)
        startButton.layer.cornerRadius = cornerRadius
        resetViewButton.layer.cornerRadius = cornerRadius
        newPictureButton.layer.cornerRadius = cornerRadius
        
        // set up initial picture
        selectedImage.image = passedImage
        
        // set up gestures
        configureGestureRecognizer()
//        gridView.setNeedsDisplay()
//       gridView.layoutIfNeeded()
        
        // set up Blurred view
        setBlurView()
    }
    
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
        //        gridViewStatus()
    }
    
    func setBlurView() {
        let blurView = UIVisualEffectView()
        blurView.frame = gridView.frame
        print("1. setBlurView: gridView: \(gridView!)\n")
        print("2. setBlurView: gridView.innerWindowPath: \(gridView.innerWindowPath)\n")
        
        blurView.effect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        gridView.insertSubview(blurView, at: 0)
        
        // set up mask
        let path = UIBezierPath (roundedRect: blurView.frame, cornerRadius: 0)
        let rectX = gridView.innerWindowPath.minX
        let rectY = gridView.innerWindowPath.minY
        let rectWidth = gridView.innerWindowPath.width
        let rectHeight = gridView.innerWindowPath.height
        
        print("3. setBlurView: gridView after insertSubview: \(gridView!)\n")
        print("4. setBlurView: gridView.innerWindowPath after insertSubview: \(gridView.innerWindowPath)\n")
        
        let rect = UIBezierPath(rect: CGRect(x: rectX, y: rectY, width: rectWidth, height: rectHeight))
        
        path.append(rect)
        path.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillColor = UIColor.white.cgColor
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        blurView.layer.mask = maskLayer
    }
    
    // MARK: - Handle Rotation Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        print("EditorViewController: viewWillTransition:to called\n")
        coordinator.animate(alongsideTransition: nil) { _ in
            
            self.gridView.layoutIfNeeded()
//            self.setBlurView()
            
            print("EditorViewController: viewWillTransition: coordinator: \(coordinator)")
            print("EditorViewController: viewWillTransition: size.width: \(size.width)")
            print("EditorViewController: viewWillTransition: size.height: \(size.height)")
            print("EditorViewController: viewWillTransition: self.view.frame.size: \(self.view.frame.size)")
            print("EditorViewController: viewWillTransition: gridView.frame: \(self.gridView.frame))")
            print("EditorViewController: viewWillTransition: gridView.innerWindowpath.size: \(self.gridView.innerWindowPath.size)")
            print("EditorViewController: viewWillTransition: gridView.innerWindowpath.minX: \(self.gridView.innerWindowPath.minX)")
            print("EditorViewController: viewWillTransition: gridView.innerWindowpath.minY: \(self.gridView.innerWindowPath.minY)")
            print("EditorViewController: viewWillTransition: gridView.innerWindowpath.maxX: \(self.gridView.innerWindowPath.maxX)")
            print("EditorViewController: viewWillTransition: gridView.innerWindowpath.maxY: \(self.gridView.innerWindowPath.maxY)")
//
//            self.mainView.setNeedsLayout()
//            self.mainView.setNeedsDisplay()
//            self.mainView.layoutIfNeeded()
            
//            self.view.setNeedsLayout()
//            self.view.setNeedsDisplay()
//            self.view.layoutIfNeeded()
//            self.gridView.setNeedsLayout()
//            self.gridView.setNeedsDisplay()
//            self.gridView.layoutIfNeeded()
            
//            self.setBlurView()
//
        }
//        resetView()
//        selectedImage.image = passedImage
//        configureGestureRecognizer()
//
    }
    
    func resetView() {
        print("resetView\n")
//                let parent = view.superview
//                view.removeFromSuperview()
//                view = nil
//                parent!.addSubview(gridView)
//                parent!.addSubview(selectedImage)
//        // set up initial picture
//        selectedImage.image = passedImage
//
//        // set up gestures
//        configureGestureRecognizer()
//
//        // set up Blurred view
//        setBlurView()
        
    }
    
    //        func gridViewStatus() {
    //            gridView.isHidden = !gridView.isHidden
    //            gridView.isOpaque = !gridView.isOpaque
    //        }
    
    func composeCreationImage() -> UIImage {
        
        // set up screen capture size
        let xloc = -gridView.innerWindowPath.minX - 2
        let yloc = -gridView.innerWindowPath.minY - 2
        let clipSize = gridView.innerWindowPath.size
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
        selectedImage.transform = selectedImage.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
    
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
            // set up limits on pan - choosenImage must be within by gridView
            let minX = gridView.innerWindowPath.minX
            let maxX = gridView.innerWindowPath.maxX
            let minY = gridView.innerWindowPath.minY
            let maxY = gridView.innerWindowPath.maxY
            
            var finalPoint = CGPoint(x: sender.view!.center.x, y: sender.view!.center.y)
            
            // get original image size
            if let panImage = selectedImage.image {
                selectedImagePixelWidth = panImage.size.width
                selectedImagePixelHeight = panImage.size.height
            }
            
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
