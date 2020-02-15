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
        
        let edgeSpacing:CGFloat = 3
        let pieceSpacing:CGFloat = 3
        
        if (collectionView == gamePieceView) {

            let maxGamePiece: CGFloat = 6
            let minGamePiece: CGFloat = 3
            
            let maxSpacing = 2 * edgeSpacing + ((maxGamePiece - 1) * pieceSpacing)
            let minSpacing = 2 * edgeSpacing + ((minGamePiece - 1) * pieceSpacing)
            
            let gamePieceViewDim1: CGFloat = collectionView.bounds.width
            let gamePieceViewDim2: CGFloat = collectionView.bounds.height
            
            let minDim = (gamePieceViewDim1 < gamePieceViewDim2 ? gamePieceViewDim1 : gamePieceViewDim2) - minSpacing
            let maxDim = (gamePieceViewDim1 > gamePieceViewDim2 ? gamePieceViewDim1 : gamePieceViewDim2) - maxSpacing
            let cellDim = minDim / minGamePiece < maxDim / maxGamePiece ? minDim / minGamePiece : maxDim / maxGamePiece
            
            let gamePieceCellSize = CGSize(width: cellDim, height: cellDim)
            return gamePieceCellSize
        } else {
            let gamePiece: CGFloat = 4
            let playFieldViewDim1: CGFloat = collectionView.bounds.width
            let playFieldViewDim2: CGFloat = collectionView.bounds.height
            
            let spacing = 2 * edgeSpacing + ((gamePiece - 1) * pieceSpacing)
            
            let minDim = (playFieldViewDim1 < playFieldViewDim2 ? playFieldViewDim1 : playFieldViewDim2) - spacing
            let cellDim = minDim / gamePiece
            let playFieldCellSize = CGSize(width: cellDim, height: cellDim)
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
