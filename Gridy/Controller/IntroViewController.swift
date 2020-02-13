//
//  IntroViewController.swift
//  Gridy
//
//  Created by Scott Bolin on 11/9/19.
//  Copyright © 2019 Scott Bolin. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class IntroViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var gridyPickButton: UIButton!
    @IBOutlet weak var cameraPickButton: UIButton!
    @IBOutlet weak var photoLibraryPickButton: UIButton!
    
    var localImages = [UIImage].init()
    var imageToPass = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cornerRadius = CGFloat(8)
        
        gridyPickButton.layer.cornerRadius = cornerRadius
        
        cameraPickButton.layer.cornerRadius = cornerRadius
        
        photoLibraryPickButton.layer.cornerRadius = cornerRadius

        // Do any additional setup after loading the view.
        collectLocalImageSet()
    }

    // MARK: - Navigation
    @IBAction func gridyPickTouched(_ sender: UIButton) {
        pickRandom()
    }
    
    @IBAction func cameraPickTouched(_ sender: UIButton) {
        displayCamera()
    }
    
    @IBAction func photoLibraryPickTouched(_ sender: UIButton) {
        displayLibrary()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditor" {
          let destinationVC = segue.destination as! EditorViewController
            // pass image to EditorViewController
            destinationVC.passedImage = imageToPass
        }
    }
    
    func displayCamera() {
        let sourceType = UIImagePickerController.SourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            let noPermissionMessage = "Looks like Gridy does not have access to your camera. Please use Setting.app on your device to permit Gridy to access your camera"
            
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if granted {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            @unknown default:
                print("staus unknown")
            }
        }
        else {
            troubleAlert(message: "Sorry, it looks like we can't access your photo library at this time")
        }
    }
    
    func displayLibrary() {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = PHPhotoLibrary.authorizationStatus()
            let noPermissionMessage = "Looks like Gridy does not have access to your photo library. Please use Setting.app on your device to permit Gridy to access your library"
            
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == .authorized {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            @unknown default:
                print("staus unknown")
            }
        }
        else {
            troubleAlert(message: "Sorry, it looks like we can't access your photo library at this time")
        }
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          imagePicker.sourceType = sourceType

          self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        processPicked(image: newImage)
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func troubleAlert(message: String?) {
        let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Got it!", style: .cancel)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    func pickRandom() {
        processPicked(image: localImages.randomElement())
    }
    
    func processPicked(image: UIImage?) {
        if let newImage = image {
            imageToPass = newImage
            performSegue(withIdentifier: "toEditor", sender: self)
        }
    }
    
    func collectLocalImageSet() {
        localImages.removeAll()
        let imageNames = ["photo_01", "photo_02", "photo_03", "photo_04", "photo_05", "photo_06", "photo_07"]
        
        for name in imageNames {
            if let image = UIImage.init(named: name) {
                localImages.append(image)
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    }
    
}
