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
            let maxGamePiece: CGFloat = 6.0
            let minGamePiece: CGFloat = 3.0
            let gamePieceViewDim1: CGFloat = collectionView.frame.width
            let gamePieceViewDim2: CGFloat = collectionView.frame.height
            
            let minDim = (gamePieceViewDim1 < gamePieceViewDim2 ? gamePieceViewDim1 : gamePieceViewDim2) - 4 * 3
            let maxDim = (gamePieceViewDim1 > gamePieceViewDim2 ? gamePieceViewDim1 : gamePieceViewDim2) - 7 * 3
            let cellDim = minDim / minGamePiece < maxDim / maxGamePiece ? minDim / minGamePiece : maxDim / maxGamePiece
            let gamePieceCellSize = CGSize(width: cellDim, height: cellDim)
            print("gamePieceViewDim1: \(gamePieceViewDim1)")
            print("gamePieceViewDim2: \(gamePieceViewDim2)")
            print("gamePieceCellSize: \(gamePieceCellSize)")
            return gamePieceCellSize
        } else {
            let gamePiece: CGFloat = 4.0
            let playFieldViewDim1: CGFloat = collectionView.frame.width
            let playFieldViewDim2: CGFloat = collectionView.frame.height
            let minDim = (playFieldViewDim1 < playFieldViewDim2 ? playFieldViewDim1 : playFieldViewDim2) - 5 * 3
            let cellDim = minDim / gamePiece
            let playFieldCellSize = CGSize(width: cellDim, height: cellDim)
            print("playFieldViewDim1: \(playFieldViewDim1)")
            print("playFieldViewDim2: \(playFieldViewDim2)")
            print("playFieldCellSize: \(playFieldCellSize)")
            return playFieldCellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return false
    }
    
}
