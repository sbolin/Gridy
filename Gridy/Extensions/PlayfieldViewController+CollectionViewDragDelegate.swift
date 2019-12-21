//
//  PlayfieldViewController+CollectionViewDragDelegate.swift
//  Gridy
//
//  Created by Scott Bolin on 12/18/19.
//  Copyright © 2019 Scott Bolin. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDragDelegate

extension PlayfieldViewController: UICollectionViewDragDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, sessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dataSource = dataSourceForCollectionView(collectionView)
        let dragCoordinator = PieceDragCoordinator(sourceIndexPath: indexPath)
        session.localContext = dragCoordinator
        self.blipPlayer?.play()
        return dataSource.dragItems(for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        guard let dragCoordinator = session.localContext as? PieceDragCoordinator,
            dragCoordinator.dragCompleted == true,
            dragCoordinator.isReordering == false
            else { return }
        let dataSource = dataSourceForCollectionView(collectionView)
        let sourceIndexPath = dragCoordinator.sourceIndexPath
        collectionView.performBatchUpdates({
            dataSource.deleteItem(at: sourceIndexPath.item)
            collectionView.deleteItems(at: [sourceIndexPath])
        })
        
    }
    
}
