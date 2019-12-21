//
//  PlayfieldViewController+CollectionViewDelegate.swift
//  Gridy
//
//  Created by Scott Bolin on 11/30/19.
//  Copyright © 2019 Scott Bolin. All rights reserved.
//

import UIKit

// MARK: UICollectionViewDelegate

extension PlayfieldViewController: UICollectionViewDelegate {
    
    //MARK: -  highlight -- highlights current cell on touch up
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            cell.layer.borderWidth = 3.0
        }
    }
    
    //MARK: - Unhighlight -- unhighlights current cell on touch up
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderColor = nil
            cell.layer.borderWidth = 0.0
        }
    }
    //MARK: - Inset cells slightly so background shows up
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
    }
}
