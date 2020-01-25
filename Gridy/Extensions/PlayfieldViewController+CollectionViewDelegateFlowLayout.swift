//
//  PlayfieldViewController+CollectionViewDelegateFlowLayout.swift
//  Gridy
//
//  Created by Scott Bolin on 11/30/19.
//  Copyright © 2019 Scott Bolin. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDelegateFlowLayout

extension PlayfieldViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (collectionView == gamePieceView) {
            var numberOfItemsPerRow: CGFloat = 6.0
            var leftAndRightPaddings: CGFloat = 16.0
            var width = (collectionView.frame.width-leftAndRightPaddings) / numberOfItemsPerRow
            var height = width
            
            if view.frame.width > view.frame.height {
                print("gamePieceView is landscape")
                numberOfItemsPerRow = 3.0
                leftAndRightPaddings = 12.0
                height = (collectionView.frame.height - leftAndRightPaddings) / numberOfItemsPerRow
                width = height
            }
            print("gamePieceView cell size is width = \(width) x height = \(height)")
            let gamePieceCellSize = CGSize(width: width, height: height)
            return gamePieceCellSize
        } else {
            let leftAndRightPaddings: CGFloat = 12.0
            let numberOfItemsPerRow: CGFloat = 4.0
            
            var width = (collectionView.frame.width-leftAndRightPaddings) / numberOfItemsPerRow
            var height = width
            
            if view.frame.width > view.frame.height {
                print("playfieldView is landscape")
                height = (collectionView.frame.height - leftAndRightPaddings) / numberOfItemsPerRow
                width = height
            }
            print("playfieldView cell size is width = \(width) x height = \(height)")
            let playfieldCellSize = CGSize(width: width, height: height)
            return playfieldCellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return false
    }
}
