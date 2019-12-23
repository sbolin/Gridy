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
            let leftAndRightPaddings: CGFloat = 16.0
            let numberOfItemsPerRow: CGFloat = 6.0

            let width = (collectionView.frame.width-leftAndRightPaddings) / numberOfItemsPerRow
            let height = width
            let cellSize = CGSize(width: width, height: height)
            return cellSize
        } else {
            let leftAndRightPaddings: CGFloat = 12.0
            let numberOfItemsPerRow: CGFloat = 4.0

            let width = (collectionView.frame.width-leftAndRightPaddings) / numberOfItemsPerRow
            let height = width
            let cellSize = CGSize(width: width, height: height)
            return cellSize
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
