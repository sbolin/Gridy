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
          let gamePiecePadding: CGFloat = 16.0
          let gamePieceViewDim1: CGFloat = collectionView.frame.width - gamePiecePadding
          let gamePieceViewDim2: CGFloat = collectionView.frame.height - gamePiecePadding

          let minDim = (gamePieceViewDim1 < gamePieceViewDim2 ? gamePieceViewDim1 : gamePieceViewDim2)
          let maxDim = (gamePieceViewDim1 > gamePieceViewDim2 ? gamePieceViewDim1 : gamePieceViewDim2)
          let cellDim = minDim / minGamePiece < maxDim / maxGamePiece ? minDim / minGamePiece : maxDim / maxGamePiece
          let gamePieceCellSize = CGSize(width: cellDim, height: cellDim)
          return gamePieceCellSize
        } else {
          let gamePiece: CGFloat = 4.0
          let gamePiecePadding: CGFloat = 8.0
          let playFieldViewDim1: CGFloat = collectionView.frame.width - gamePiecePadding
          let playFieldViewDim2: CGFloat = collectionView.frame.height - gamePiecePadding
          let minDim = (playFieldViewDim1 < playFieldViewDim2 ? playFieldViewDim1 : playFieldViewDim2)
          let maxDim = (playFieldViewDim1 > playFieldViewDim2 ? playFieldViewDim1 : playFieldViewDim2)
          let cellDim = minDim / gamePiece
          let playFieldCellSize = CGSize(width: cellDim, height: cellDim)
          return playFieldCellSize
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
