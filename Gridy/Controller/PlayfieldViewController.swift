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
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var quickViewButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var confettiView: UIView!
    
    //MARK: - Properties
    
    var score = Int()
    
    var selectedImage = UIImage()
    var baseImage = [UIImage]()
        
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
            }
        }
        
        return PieceDataSource(pieceCollection: baseImage.shuffled())
    }()
    
    private lazy var playFieldDataSource: PieceDataSource = {
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
        finalScoreLabel.isHidden = true
        shareButton.isHidden = true
        shareButton.isEnabled = false
        confettiView.isHidden = true
        
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
    
//    MARK: Handle iPad landscape view
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let flowLayout = playfieldView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
        
        coordinator.animate(alongsideTransition: nil) { _ in

        }
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            if UIDevice.current.model.hasPrefix("iPad") {
                 print("iPad")
            } else {
                 print("not an iPad")
            }
        } else {
            print("Portrait")
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
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
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

        let renderer = UIGraphicsImageRenderer(size: playfieldView.bounds.size)
        let image = renderer.image { ctx in
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let textColor = UIColor(named: "#1A936F")
            let attrs1: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "TimeBurner", size: 44)!,
                .foregroundColor: textColor!,
                .paragraphStyle: paragraphStyle
            ]
            let attrs2: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "TimeBurner", size: 44)!,
                .foregroundColor: UIColor.lightGray,
                .paragraphStyle: paragraphStyle
            ]
            let string = "Final Score: \(score)"
            let attributedString1 = NSAttributedString(string: string, attributes: attrs1)
            let attributedString2 = NSAttributedString(string: string, attributes: attrs2)

            
            playfieldView.drawHierarchy(in: playfieldView.bounds, afterScreenUpdates: true)
            
            attributedString2.draw(with: CGRect(x: playfieldView.bounds.minX + 12, y: playfieldView.bounds.midY - 28, width: playfieldView.bounds.width, height: playfieldView.bounds.height), options: .usesLineFragmentOrigin, context: nil)

            attributedString1.draw(with: CGRect(x: playfieldView.bounds.minX + 11, y: playfieldView.bounds.midY - 29, width: playfieldView.bounds.width, height: playfieldView.bounds.height), options: .usesLineFragmentOrigin, context: nil)
        }

        return image
    }
    
    // MARK: - Game Over Check
    // check if dataSource is the same as baseImage, handle game over if true
    func checkIfGameOver(dataSource: PieceDataSource) {
        if dataSource.pieceCollection == baseImage {
            handleGameOver()
        }
    }
    
    // handle game over event
    func handleGameOver() {
        
        confettiView.isHidden = false
        let confetti = ConfettiView()
        confetti.confettiImage = UIImage(named: "confetti")
        confetti.translatesAutoresizingMaskIntoConstraints = false
        confettiView.addSubview(confetti)
        confetti.clipsToBounds = true
        
        shareButton.isHidden = false
        shareButton.layer.cornerRadius = 12.0
        shareButton.isEnabled = true
        gamePieceView.dragInteractionEnabled = false
        playfieldView.dragInteractionEnabled = false
        quickViewButton.isHidden = true
        imageView.isHidden = false
        imageView.image = UIImage(named: "GameOver")
        finalScoreLabel.text = "Final Score: \(score)"
        finalScoreLabel.isHidden = false
        
        NSLayoutConstraint.activate([
            confetti.leadingAnchor.constraint(equalTo: confettiView.leadingAnchor),
            confetti.trailingAnchor.constraint(equalTo: confettiView.trailingAnchor),
            confetti.topAnchor.constraint(equalTo: confettiView.topAnchor),
            confetti.bottomAnchor.constraint(equalTo: confettiView.bottomAnchor)
        ])
        
        imageView.alpha = 1
        UIView.animate(withDuration: 5.0, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.imageView.alpha = 0
            self.finalScoreLabel.alpha = 0
            self.confettiView.alpha = 0
        }, completion: {[weak self] ended in
            self?.imageView.isHidden = true
            self?.finalScoreLabel.isHidden = true
            self?.confettiView.isHidden = true
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
