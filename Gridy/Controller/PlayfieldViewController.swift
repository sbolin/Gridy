//
//  PlayfieldViewController.swift
//  Gridy
//
//  Copyright © 2019 Scott Bolin. All rights reserved.
//

import UIKit
import AVFoundation

class PlayfieldViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var gamePieceView: UICollectionView!
    @IBOutlet weak var playfieldView: UICollectionView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var quickViewButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    //MARK: - Properties
    
    var score = Int()
    
    var selectedImage = UIImage()
    var baseImage = [UIImage]()
    
    var counter = 0
    
    var blipPlayer: AVAudioPlayer? = nil
    var bloopPlayer: AVAudioPlayer? = nil
    
    
    private lazy var gamePieceDataSource: PieceDataSource = {
        let imageWidth = selectedImage.scale * selectedImage.size.width
        let imageHeight = selectedImage.scale * selectedImage.size.height
        let cropWidth = imageWidth / 4.0
        let cropHeight = imageHeight / 4.0
        
        for col in 0...3 {
            for row in 0...3 {
                let locX = CGFloat(row) * cropWidth
                let locY = CGFloat(col) * cropHeight
                baseImage.append(selectedImage.cropToBounds(posX: locX, posY: locY, width: cropWidth, height: cropHeight))
                counter = counter + 1
            }
        }
        
        return PieceDataSource(pieceCollection: baseImage.shuffled())
    }()
    private lazy var playFieldDataSource: PieceDataSource = {
        //        return PieceDataSource(pieceCollection: [selectedImage])
        guard let blankImage = UIImage(named: "Blank") else { return PieceDataSource(pieceCollection: []) }
        let blankPieceCollection = [UIImage](repeating: blankImage, count: 16)
        
        return PieceDataSource(pieceCollection: blankPieceCollection)
    }()
    
    func loadSound(filename: String) -> AVAudioPlayer {
        let url = Bundle.main.url(forResource: filename, withExtension: "mp3")
        var player = AVAudioPlayer()
        do {
            try player = AVAudioPlayer(contentsOf: url!)
            player.prepareToPlay()
        } catch {
            print("Error loading \(url!): \(error.localizedDescription)")
        }
        return player
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "\(score)"
        imageView.image = selectedImage
        imageView.isHidden = true
        shareButton.isHidden = true
        shareButton.isEnabled = false
        
        let cornerRadius = CGFloat(12)
        newGameButton.layer.cornerRadius = cornerRadius
        
        self.blipPlayer = self.loadSound(filename: "blip")
        self.bloopPlayer = self.loadSound(filename: "bloop")
        
        for collectionView in [gamePieceView, playfieldView] {
            if let collectionView = collectionView {
                collectionView.dragInteractionEnabled = true
                collectionView.dataSource = dataSourceForCollectionView(collectionView)
                collectionView.delegate = self
                collectionView.dragDelegate = self
                collectionView.dropDelegate = self
                collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    @IBAction func newGameTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Show hint pic, then fade out
    @IBAction func quickViewTapped(_ sender: UIButton) {
        imageView.isHidden = false
        imageView.image = selectedImage
        
        imageView.alpha = 1
        UIView.animate(withDuration: 3.0, delay: 0.0, options: [.curveEaseOut], animations: {
            self.imageView.alpha = 0
        }, completion: {[weak self] ended in
            self?.imageView.isHidden = true
        })
    }
    
    //MARK: Handle Share at end of game
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        displaySharingOptions(sender: sender)
    }
    
    func displaySharingOptions(sender: Any) {
        // define and prepare content to share
        let note = "Puzzle Solved in \(score) moves!"
        let image = composeShareImage()
        let items = [image as Any, note as Any]
        
        // create activity view controller
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        // limit share to messages, email
//        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook]
//        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToTwitter]
//        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToWeibo]
//        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToTencentWeibo]
//        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToFlickr]
        
        // bandaid for iPad
        activityViewController.popoverPresentationController?.sourceView = sender as? UIView
        
        // present activity view controller
        present(activityViewController, animated: true, completion: nil)
    }
    
    func composeShareImage() -> UIImage {

        
//        let renderer = UIGraphicsImageRenderer(size: super.view.bounds.size)
//        let image = renderer.image { ctx in
//            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//        }
        let renderer = UIGraphicsImageRenderer(size: playfieldView.bounds.size)
        let image = renderer.image { ctx in
            playfieldView.drawHierarchy(in: playfieldView.bounds, afterScreenUpdates: true)
        }

        return image
    }
    
    // MARK: - Game Over Check
    // check if dataSource is the same as baseImage, handle game over if true
    func checkIfGameOver(dataSource: PieceDataSource) {
        if dataSource.pieceCollection == baseImage {
            print("passed game over check")
            handleGameOver()
        }
    }
    
    // handle game over event
    func handleGameOver() {
        print("in handlegameover function")
        shareButton.isHidden = false
        shareButton.layer.cornerRadius = 12.0
        shareButton.isEnabled = true
        gamePieceView.dragInteractionEnabled = false
        playfieldView.dragInteractionEnabled = false
        
//        gamePieceView.isHidden = true
        quickViewButton.isHidden = true
        
        imageView.isHidden = false
        imageView.image = UIImage(named: "GameOver")
        
        imageView.alpha = 1
        UIView.animate(withDuration: 5.0, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.imageView.alpha = 0
        }, completion: {[weak self] ended in
            self?.imageView.isHidden = true
        })
    }
}

// MARK: - Methods to setup DataSource for collection views
extension PlayfieldViewController {
    func dataSourceForCollectionView(_ collectionView: UICollectionView) -> PieceDataSource {
        if (collectionView == gamePieceView) {
            return gamePieceDataSource
        } else {
            return playFieldDataSource
        }
    }
}
