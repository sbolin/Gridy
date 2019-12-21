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
    
    //MARK: - Properties
    //    var gamePieceCell = UICollectionViewCell()
    //    var playFieldCell = UICollectionViewCell()
    
    var score = Int()
    
    var selectedImage = UIImage()
    var returnImage = [UIImage]()
    
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
                returnImage.append(selectedImage.cropToBounds(posX: locX, posY: locY, width: cropWidth, height: cropHeight))
                counter = counter + 1
            }
        }
                
        return PieceDataSource(pieceCollection: returnImage.shuffled())
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
    
    // MARK: - Show full pic, then fade out
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
